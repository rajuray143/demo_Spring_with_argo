pipeline {
    agent any

    tools {
        maven 'Maven 3.8.8'
    }

    environment {
        DOCKERHUB_USER = "rajuray143"
        IMAGE_NAME = "demo_Spring_with_argo"
        FULL_IMAGE = "${DOCKERHUB_USER}/${IMAGE_NAME}"
        CONTAINER_NAME = "demo_Spring_with_argo-container"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/rajuray143/demo_Spring_with_argo'
            }
        }

        stage('Build JAR') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t %FULL_IMAGE%:latest .'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    bat 'docker login -u %DOCKER_USER% -p %DOCKER_PASS%'
                }
            }
        }

        stage('Docker Push') {
            steps {
                bat 'docker push %FULL_IMAGE%:latest'
            }
        }

    }

    post {
        success {
            echo '🚀 Image pushed to Docker Hub and application deployed'
        }
        failure {
            echo '❌ CI/CD failed'
        }
    }
}
