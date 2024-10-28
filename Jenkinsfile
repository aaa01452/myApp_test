pipeline {
    agent any
    tools {
        nodejs 'node 18.20.4'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('fe648b98-7b73-4e5a-85d1-2a71ad0487bb')
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
                sh 'docker tag myapp_test:latest ghcr.io/aaa01452/myapp_test:latest'
                sh 'echo $DOCKERHUB_CREDENTIALS | docker login ghcr.io -u aaa01452 --password-stdin'
                sh "docker push ghcr.io/aaa01452/myapp_test:latest"
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
