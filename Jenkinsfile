pipeline {
    agent any

    tools {
        jdk 'JDK 21'
        maven 'Maven 3.8.8'
    }

    environment {
        DOCKERHUB_USER = "rajuray143"
        IMAGE_NAME = "demo_spring_with_argo"
        FULL_IMAGE = "${DOCKERHUB_USER}/${IMAGE_NAME}"
        IMAGE_TAG  = "${BUILD_NUMBER}"
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
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t %FULL_IMAGE%:%IMAGE_TAG% .'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'docker login -u %DOCKER_USER% -p %DOCKER_PASS%'
                }
            }
        }

        stage('Docker Push') {
            steps {
                sh 'docker push %FULL_IMAGE%:%IMAGE_TAG%'
            }
        }
    }

    post {
        success {
            echo "🚀 Image pushed: ${FULL_IMAGE}:${IMAGE_TAG}"
        }
        failure {
            echo '❌ CI/CD failed'
        }
    }
}
