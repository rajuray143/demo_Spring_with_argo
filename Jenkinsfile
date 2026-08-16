
pipeline {
    agent any

    tools {
        jdk 'JDK 21'
        maven 'Maven 3.8.8'
    }

    environment {
    GCP_PROJECT = "springboot-demo-503613"
    GCP_REGION = "asia-south1"
    AR_REPOSITORY = "springboot-repo"
    IMAGE_NAME = "demo-spring-with-argo"
    IMAGE_TAG = "${BUILD_NUMBER}"
    FULL_IMAGE = "${GCP_REGION}-docker.pkg.dev/${GCP_PROJECT}/${AR_REPOSITORY}/${IMAGE_NAME}"
 }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/rajuray143/demo_Spring_with_argo.git'
            }
        }

        stage('Check Environment') {
            steps {
                sh '''
                    echo "===== JAVA_HOME ====="
                    echo "$JAVA_HOME"

                    echo "===== JAVA ====="
                    which java
                    java -version

                    echo "===== JAVAC ====="
                    which javac
                    javac -version

                    echo "===== MAVEN ====="
                    which mvn
                    mvn -version
                '''
            }
        }

        stage('Build JAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $FULL_IMAGE:$IMAGE_TAG .'
            }
        }

        stage('Google Cloud Login') {
            steps {
                sh '''
                gcloud auth list

                gcloud config set project "$GCP_PROJECT"

                gcloud auth configure-docker \
                "$GCP_REGION-docker.pkg.dev" \
                --quiet
                '''
            }
        }

        stage('Docker Push') {
            steps {
                sh 'docker push $FULL_IMAGE:$IMAGE_TAG'
            }
        }
        stage('Deploy to GKE') {
            steps {
                sh '''
                    echo "===== Get GKE Credentials ====="

                    gcloud container clusters get-credentials springboot-cluster \
                        --region asia-south1 \
                        --project springboot-demo-503613

                    echo "===== Apply Kubernetes Manifests ====="

                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml

                    echo "===== Update Image ====="

                    kubectl set image deployment/demo-spring \
                        demo-spring="$FULL_IMAGE:$IMAGE_TAG"

                    echo "===== Wait for Deployment ====="

                    kubectl rollout status deployment/demo-spring
                '''
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
