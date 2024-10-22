void setBuildStatus(String message, String context, String state) {
    withCredentials([string(credentialsId: 'fe648b98-7b73-4e5a-85d1-2a71ad0487bb', variable: 'TOKEN')]) {
        sh """
            set -x
            curl \"https://api.github.com/repos/org/repo/statuses/$GIT_COMMIT?access_token=$TOKEN\" \
                -H \"Content-Type: application/json\" \
                -X POST \
                -d \"{\\\"description\\\": \\\"$message\\\", \\\"state\\\": \\\"$state\\\", \\\"context\\\": \\\"$context\\\", \\\"target_url\\\": \\\"$BUILD_URL\\\"}\"
        """
    } 
}

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
        }
        success {
            echo 'Build & Deployment Successful'
            setBuildStatus('Build & Deployment Successful', 'Jenkins', 'success')
        }
        failure {
            echo 'Build or Deployment Failed'
            setBuildStatus('Build or Deployment Failed', 'Jenkins', 'failure')
        }
    }
}
