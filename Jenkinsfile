pipeline {
    agent any
    environment {
        CI = 'true'
    }
    stages {
        stage('print env') {
            steps {
                sh 'printenv'
            }
        }
        stage('Build') {
            steps {
                echo 'step 1'
            }
        }
        stage('Test') {
            steps {
                echo 'step 2'
            }
        }
        stage('Deliver for develop') {
            when {
                branch 'develop'
            }
            steps {
                echo 'Deliver for develop'
            }
        }
        stage('Deliver for main') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deliver for main'
            }
        }
    }
}
