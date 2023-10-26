pipeline {
    agent any

    tools {
        nodejs 'nodejs'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the GitHub repository
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: 'https://github.com/Brahim98-cell/Devops_Project.git']]])
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
                    def artifactPath = filesByGlob[0].path
                    def artifactExists = fileExists artifactPath

                    if (artifactExists) {
                        nexusArtifactUploader(
                            nexusVersion: 'nexus3',
                            protocol: 'http',
                            nexusUrl: 'http://192.168.33.10:8081',
                            groupId: 'tn.esprit',
                            version: '1.0',
                            repository: 'maven-central-repo',
                            credentialsId: 'nexus_cred',
                            artifacts: [
                                [artifactId: pom.DevOps_Project, // Use pom.artifactId
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: pom.DevOps_Project, // Use pom.artifactId
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        )
                    } else {
                        error "*** File: ${artifactPath} could not be found"
                    }
                }
            }
        }

        stage('Checkout front') {
            steps {
                // Checkout the code from the GitHub repository
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: 'https://github.com/Brahim98-cell/Devops_Project_front.git']])
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
