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
