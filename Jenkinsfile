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
        stage('Set github status') { // Corrected typo
            steps {
                echo 'Set github status'
            }
        }
        stage('Install Curl') {
            steps {
                echo 'Install Curl'
                script {
                    sh '''
                        apk update && apk add curl
                    '''
                }
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
        stage('Build Nginx Docker Image') {
            steps {
                script {
                    echo '拉取 Nginx 官方镜像并打标签'
                    // 拉取 Nginx 官方镜像并打标签
                    sh "docker pull nginx:latest"
                    sh "docker tag nginx:latest ghcr.io/ethan-omniway/nginx:latest"
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
