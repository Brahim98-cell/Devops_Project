pipeline {
    agent any

    tools {
        nodejs 'nodejs'
    }
      environment {
        DOCKER_IMAGE_Back_NAME = 'brahim98/devops_project_back:MySpringimage'
        DOCKER_IMAGE_Front_NAME = 'brahim98/devops_project_front:MyAngularimage'

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
            steps {
                script {
                    // Build the Docker image for the Spring Boot app
                    sh "docker build -t $DOCKER_IMAGE_Back_NAME ."
                }
            }
        }

        stage('Push image spring') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'docker-hub-creds',url: ""]) {
                        // Push the Docker image to Docker Hub
                        sh "docker push $DOCKER_IMAGE_Back_NAME"
                    }
                }
            }}


        
        
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
                    sh 'ng build'
                }
            }
        }
stage('Build image Angular') {
            steps {
                script {
                    // Build the Docker image for the Spring Boot app
                    sh "docker build -t $DOCKER_IMAGE_Front_NAME ."
                }
            }
        }

        stage('Push image Angular') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'docker-hub-creds',url: ""]) {
                        // Push the Docker image to Docker Hub
                        sh "docker push $DOCKER_IMAGE_Front_NAME"
                    }
                }
            }}




         stage('Build and Deploy') {
    steps {
        // Checkout your source code from the version control system if needed

        // Build the Docker images for your Spring Boot backend and Angular frontend

        // Start the application stack using Docker Compose
        sh "/usr/bin/docker-compose -f docker-compose.yml up -d"
    }
}
                stage('Build and Deploy Grafana and Prometheus') {
    steps {
        // Checkout your source code from the version control system if needed

        // Build the Docker images for your Spring Boot backend and Angular frontend

        // Start the application stack using Docker Compose
        sh "/usr/bin/docker-compose -f docker-compose2.yml up -d"
    }
}




    }

    post {
        success {

             emailext subject: 'Successful Build Notification',
                body: 'The Jenkins pipeline build was successful.',
                to: 'frigui.brahim@esprit.tn',
                from: 'frigui.brahim@esprit.tn'
            echo 'Build successful!'
        }

        failure {

             emailext subject: 'Failed Build Notification',
                body: 'The Jenkins pipeline build failed. Please investigate.',
                to: 'frigui.brahim@esprit.tn',
                from: 'frigui.brahim@esprit.tn'
            echo 'Build failed. Please investigate.'
        }
    }
}
