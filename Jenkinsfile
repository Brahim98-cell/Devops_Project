pipeline {
    agent any



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


    }



        stage('Checkout front') {
            steps {
                // Checkout the code from the GitHub repository
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: 'https://github.com/Brahim98-cell/Devops_Project_front.git']]])
            }
        }

          stage('Build Angular') {
                    steps {
                        dir('frontend') {
                            sh 'npm install'
                            sh 'ng build --prod'
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
