pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
              git credentialsId: 'githubtoken', url: 'https://github.com/busipatianil/Laravel-Iac-Eks.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -f testlaravel/laravel-app:latest .'
            }
        }
}  
}    
        
