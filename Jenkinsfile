pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        cluster_name = "laravel-eks-deployment"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/your-repo/laravel-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t your-dockerhub-repo/laravel-app:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-cred', url: 'https://index.docker.io/v1/']) {
                    sh 'docker push your-dockerhub-repo/laravel-app:latest'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withAWS(credentials: 'aws-cred', region: "$AWS_REGION") {
                    sh 'aws eks update-kubeconfig --name $EKS_CLUSTER'
                    sh 'kubectl apply -f deployment.yaml'
                }
            }
        }
    }
}
