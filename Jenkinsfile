pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'composer install --no-dev --optimize-autoloader'
                sh 'npm install && npm run prod' // Or yarn
                sh 'php artisan package:discover --ansi'
                sh 'php artisan config:cache'
                sh 'php artisan route:cache'
                // Add static code analysis and unit testing steps here
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'php artisan test'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    def appName = "helloapp" // Replace with your app name
                    def imageTag = "${appName}:${env.GIT_COMMIT}"
                    env.DOCKER_IMAGE = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${imageTag}"
                    docker.build(env.DOCKER_IMAGE, '.')
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry("https://${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com", 'aws') {
                        docker.image(env.DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withAWS(credentials: 'your-aws-credentials') { // Configure AWS credentials in Jenkins
                    sh '''
                        terraform init
                        terraform apply -auto-approve -var="docker_image=${env.DOCKER_IMAGE}"
                    '''
                }
            }
        }

        stage('Ansible Playbook') {
            steps {
                withCredentials([string(credentialsId: 'your-kubeconfig', variable: 'KUBECONFIG_CONTENT')]) { // Configure kubeconfig in Jenkins
                    sh '''
                        mkdir -p ~/.kube
                        echo "$KUBECONFIG_CONTENT" > ~/.kube/config
                        export KUBECONFIG=~/.kube/config
                    '''
                }
                sh '''
                    ansible-playbook -i inventory/eks_hosts deploy.yml -e "docker_image=${env.DOCKER_IMAGE}"
                '''
            }
        }

        // Optional: Integration/E2E Tests
        // stage('Integration Tests') { ... }

        // Optional: Verification/Rollback
        // stage('Verification') { ... }
    }

    environment {
        AWS_ACCOUNT_ID = credentials('aws-account-id') // Configure AWS account ID as a secret
        AWS_REGION = 'us-east-1' // Replace with your AWS region
    }
}
