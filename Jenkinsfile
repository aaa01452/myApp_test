pipeline {
    agent {
        docker {
            image 'node:18-alpine'
            reuseNode true
        }
    }
    stages {
        stage('Check env') {
            steps {
                sh 'printenv'
            }
        }
        stage('Install Git') {
            steps {
                echo 'Install Git inside the node container'
                sh '''
                    apk update && apk add git
                '''
            }
        }
        stage('Checkout Code') {
            steps {
                echo 'Pulling...' + env.GITHUB_PR_SOURCE_BRANCH
            }
        }
        stage("Clone Git Repository") {
            steps {
                echo 'Ready to Clone'
                git(
                    url: "https://github.com/aaa01452/myApp_test",
                    branch: env.GITHUB_PR_SOURCE_BRANCH
                )
            }
        }
        stage('Build') {
            steps {
                echo 'Checking Node and Npm version'
                sh '''
                    ls -la
                    node -v
                    npm -v
                '''
                echo 'Installing dependencies and building the project'
                sh '''
                    ls -la
                '''
            }
        }
    }
    post {
        always {
            cleanWs()
            echo 'Pipeline finished'
            echo "Build #${env.BUILD_NUMBER} ended"
            echo "Build #${env.BUILD_NUMBER} ended"
            githubPRStatusPublisher(
                buildMessage: 'Build finished', 
                statusMsg: githubPRMessage('${GITHUB_PR_COND_REF} run ended'), 
                statusVerifier: allowRunOnStatus('SUCCESS'), 
                unstableAs: 'FAILURE',
                errorHandler: 'someErrorHandler' // 填入適當的錯誤處理程序
            )
        }
        success {
            echo 'Build & Deployment Successful'
        }
        failure {
            echo 'Build or Deployment Failed'
        }
    }
}
