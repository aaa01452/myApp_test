pipeline {
    agent {
        docker {
            image 'node:18-alpine'
            reuseNode true
        }
    }
    environment {
        GITHUB_TOKEN = credentials('fe648b98-7b73-4e5a-85d1-2a71ad0487bb')  // Jenkins 內配置的 GitHub Token 憑證
        REPO_OWNER = 'aaa01452'                     // GitHub Repo 所屬人或組織
        REPO_NAME = 'myApp_test'                // GitHub Repo 名稱
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
        success {
            echo 'Build & Deployment Successful'
            script {
                def response = httpRequest(
                    acceptType: 'APPLICATION_JSON',
                    contentType: 'APPLICATION_JSON',
                    httpMode: 'POST',
                    customHeaders: [[name: 'Authorization', value: "token ${env.GITHUB_TOKEN}"]],
                    url: "https://api.github.com/repos/${env.REPO_OWNER}/${env.REPO_NAME}/statuses/${env.GIT_COMMIT}",
                    requestBody: """
                    {
                        "state": "success",
                        "description": "Jenkins build succeeded",
                        "context": "continuous-integration/jenkins"
                    }
                    """
                )

                echo "GitHub API response: ${response}"
            }
        }
        failure {
            echo 'Build or Deployment Failed'
            script {
                def response = httpRequest(
                    acceptType: 'APPLICATION_JSON',
                    contentType: 'APPLICATION_JSON',
                    httpMode: 'POST',
                    customHeaders: [[name: 'Authorization', value: "token ${env.GITHUB_TOKEN}"]],
                    url: "https://api.github.com/repos/${env.REPO_OWNER}/${env.REPO_NAME}/statuses/${env.GIT_COMMIT}",
                    requestBody: """
                    {
                        "state": "failure",
                        "description": "Jenkins build failed",
                        "context": "continuous-integration/jenkins"
                    }
                    """
                )
                echo "GitHub API response: ${response}"
            }
        }
        always {
            cleanWs()
            echo 'Pipeline finished'
            echo "Build #${env.BUILD_NUMBER} ended"
        }
    }
}
