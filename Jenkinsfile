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
        stage('Set giuthub status') {
            steps {
                echo 'Set giuthub status'
            }
        }
        stage('Install Curl') {
            steps {
                echo 'Install Curl'
                script {
                    // Update package list and install curl
                    sh '''
                        apk update && apk add curl
                    '''
                }
            }
        }
        stage('Install Docker') {
            steps {
                echo 'Install Docker'
                script {
                    try {
                        setGitHubPullRequestStatus(context: 'Install Docker', message: 'Install Docker', state: 'PENDING')
                        sh '''
                        apk add docker
                        docker version
                    '''
                        setGitHubPullRequestStatus(context: 'Install Docker', message: 'Install Docker', state: 'SUCCESS')
                    } catch (e) {
                        echo "Caught: ${err}"
                        setGitHubPullRequestStatus(context: 'Install Docker', message: 'Install Docker', state: 'ERROR')
                    }
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
                try {
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
                    setGitHubPullRequestStatus(context: 'Build', message: 'Build image', state: 'PENDING')
                    echo 'npm run build image'
                    sh '''
                        docker build  --no-cache -t myApp_test:latest .
                        docker image ls
                    '''
                    setGitHubPullRequestStatus(context: 'Build', message: 'Build image', state: 'SUCCESS')
                } cache (e) {
                    echo "Caught: ${err}"
                    setGitHubPullRequestStatus(context: 'Build', message: 'build error', state: 'ERROR')
                }

            }
        }
    }
    post {
        success {
            echo 'Build & Deployment Successful'
        // setGitHubPullRequestStatus(context: 'Robot', message: 'Jenkins Success', state: 'SUCCESS')
        }
        failure {
            echo 'Build or Deployment Failed'
        // setGitHubPullRequestStatus(context: 'Robot', message: 'Jenkins Failed', state: 'FAILURE')
        }
        always {
            cleanWs()
            echo 'Pipeline finished'
            echo "Build #${env.BUILD_NUMBER} ended"
        }
    }
}
