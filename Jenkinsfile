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


        
        stage('Checkout front') {
            steps {
                // Checkout the code from the GitHub repository
                checkout([$class: 'GitSCM', branches: [[name: 'main']], userRemoteConfigs: [[url: 'https://github.com/Brahim98-cell/Devops_Project_front.git']]])
            }
        }

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
