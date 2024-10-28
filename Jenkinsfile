pipeline {
    agent any
    tools {
        nodejs 'node 18.20.4'
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
                sh 'node -v'
            }
        }
        stage('Test') {
            steps {
                echo 'step 2'
            }
        }
        stage('Run Unit Test') {
            when {
                not {
                    anyOf {
                        branch 'main'
                        branch 'develop'
                    }
                }
            }
            steps {
                echo 'Run Unit Test'
            }
        }
        stage('Deliver for develop') {
            when {
                branch 'develop'
            }
            steps {
                sh 'docker image ls'
                echo 'Deliver for develop'
                sh 'docker build -t myapp_test:latest .'
                sh 'docker image ls'
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
