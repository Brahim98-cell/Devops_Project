pipeline {
    agent any

    tools {
        nodejs 'nodejs'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the GitHub repository
                checkout([$class: 'GitSCM', branches: [[name: 'main']], userRemoteConfigs: [[url: 'https://github.com/Brahim98-cell/Devops_Project.git']]])
            }
        }

        stage('Build') {
            steps {
                // Build the project using Maven
                sh 'mvn clean package' // Adjust this to your actual build command
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'mvn test'  // Assuming you use Maven and JUnit for testing
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    sh 'mvn clean verify sonar:sonar ' +
                       '-Dsonar.projectKey=sonar ' +
                       '-Dsonar.projectName=sonar ' +
                       '-Dsonar.host.url=http://192.168.33.10:9000 ' +
                       '-Dsonar.login=sqp_c0339d4de46c555f337f14b58dd30e2a7defa9ec'
                }
            }
        }

        stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    def pom = readMavenPom file: "pom.xml"
                    def filesByGlob = findFiles(glob: "target/*.${pom.packaging}")
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    def artifactPath = filesByGlob[0].path
                    def artifactExists = fileExists artifactPath
                    if (artifactExists) {
                        echo "* File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}"
                        nexusArtifactUploader(
                            nexusVersion: 'nexus3',
                            protocol: 'http',
                            nexusUrl: '192.168.33.10:8081', // Corrected the URL
                            groupId: 'pom.tn.esprit',
                            version: 'pom.1.0', // Corrected the version
                            repository: 'test',
                            credentialsId: 'nexusCredential',
                            artifacts: [
                                [artifactId: pom.artifactId, // Use the variable directly
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging]
                            ]
                        )
                    } else {
                        error "* File: ${artifactPath}, could not be found"
                    }
                }
            }
        }
stage('Build image spring') {
     bat 'docker build -t brahim98/devops_project:build . '    }


stage('Push image spring') {
    docker.withRegistry('docker-hub-creds',url: "") {
        bat 'docker push brahim98/devops_project:build'
    }
}

        stage('Checkout front') {
            steps {
                // Checkout the code from the GitHub repository
                checkout([$class: 'GitSCM', branches: [[name: 'main']], userRemoteConfigs: [[url: 'https://github.com/Brahim98-cell/Devops_Project_front.git']]])
            }
        }

        stage('Build Angular') {
            steps {
                dir('frontend') {
                    sh 'npm install'
                    sh 'npm install -g @angular/cli'
                    sh 'ng build'
                }
            }
        }

        stage('Build and Push Docker Image Frontend') {
            steps {
                script {
                    // Build the Docker image for the Spring Boot app
                    sh 'docker build -t my-Angular-app:latest -f Dockerfile .'
                    
                    // Authenticate with Docker Hub using credentials (ensure credentials are configured in Jenkins)
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME',  url: "" )]) {
                        // Push the Docker image to Docker Hub
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                        sh 'docker push my-Angular-app:latest'
                    }
                }
            }
        }
    }

    post {
        success {
            // Notify or perform additional tasks on successful build
            echo 'Build successful!'
        }

        failure {
            // Notify or perform additional tasks on build failure
            echo 'Build failed. Please investigate.'
        }
    }
}
