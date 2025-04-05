pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
              git credentialsId: 'githubtoken', url: 'https://github.com/busipatianil/Laravel-Iac-Eks.git'
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
