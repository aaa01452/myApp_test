pipeline {
    agent {
        docker {
            image 'node:18-alpine'
            reuseNode true
        }
    }
    triggers {
        githubPullRequests events: [Open(), commitChanged()], spec: '', triggerMode: 'HEAVY_HOOKS'
    }
    environment {
        GITHUB_TOKEN = credentials('fe648b98-7b73-4e5a-85d1-2a71ad0487bb')
    }
    stages {
        stage('Install Dependencies') {
            steps {
                echo 'Install Curl'
                sh '''
                   apk update
                   apk add --no-cache curl \
                   bash \
                   libc6-compat \
                   device-mapper \
                   make gcc g++ \
                   openssl \
                   iptables \
                   util-linux
                '''
            }
        }
        stage('Checkout Code') {
            steps {
                echo 'Pulling...' + env.GITHUB_PR_SOURCE_BRANCH
            }
        }
        stage('Clone Git Repository') {
            steps {
                echo 'Ready to Clone'
                git(
                    url: 'https://github.com/aaa01452/myApp_test',
                    branch: env.GITHUB_PR_SOURCE_BRANCH
                )
            }
        }
        stage('Build') {
            steps {
                script {
                    setGitHubPullRequestStatus(context: 'Build', message: 'Check version', state: 'PENDING')
                    echo 'Checking Node and Npm version'
                    sh '''
                        ls -la
                        node -v
                        npm -v
                    '''
                    setGitHubPullRequestStatus(context: 'Build', message: 'Check version', state: 'SUCCESS')
                    echo 'Installing dependencies and building the project'
                    sh '''
                        ls -la
                    '''
                }
            }
        }
        stage('Image Build') {
            steps {
                script {
                    echo 'Image Build'
                    setGitHubPullRequestStatus(context: 'Image Build', message: 'Build image', state: 'PENDING')
                    echo 'npm run build image'
                    sh '''
                        docker build  --no-cache -t myApp_test:latest .
                        docker image ls
                    '''
                    setGitHubPullRequestStatus(context: 'Image Build', message: 'Build image', state: 'SUCCESS')
                }
            }
        }
    }
    post {
        success {
            echo 'Build & Deployment Successful'
        }
        failure {
            echo 'Build or Deployment Failed'
        }
        always {
            cleanWs()
            echo 'Pipeline finished'
            echo "Build #${env.BUILD_NUMBER} ended"
        }
    }
}
