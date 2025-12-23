pipeline {
    agent any

    tools {
        maven 'Maven 3.8.8'
    }

    environment {
        DOCKERHUB_USER = "rajuray143"
        IMAGE_NAME = "springboot-cicd-demo"
        FULL_IMAGE = "${DOCKERHUB_USER}/${IMAGE_NAME}"
        CONTAINER_NAME = "springboot-cicd-container"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/rajuray143/demo-with-ci-cd.git'
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
