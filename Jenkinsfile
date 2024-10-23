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
        GITHUB_TOKEN = credentials('fe648b98-7b73-4e5a-85d1-2a71ad0487bb')  // Jenkins 內配置的 GitHub Token 憑證
    //     REPO_OWNER = 'aaa01452'                     // GitHub Repo 所屬人或組織
    //     REPO_NAME = 'myApp_test'                // GitHub Repo 名稱
    }
    stages {
        stage('Set giuthub status') {
            steps {
                echo 'Set giuthub status'
                setGitHubPullRequestStatus(context: 'Robot', message: 'The build is in progress', state: 'PENDING')
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
                setGitHubPullRequestStatus(context: 'Robot', message: 'Install Curl', state: 'PENDING')
            }
        }
        stage('Check env') {
            steps {
                sh 'printenv'
            }
        }
    // stage('Checkout Code') {
    //     steps {
    //         echo 'Pulling...' + env.GITHUB_PR_SOURCE_BRANCH
    //     }
    // }
    // stage('Clone Git Repository') {
    //     steps {
    //         echo 'Ready to Clone'
    //         git(
    //             url: 'https://github.com/aaa01452/myApp_test',
    //             branch: env.GITHUB_PR_SOURCE_BRANCH
    //         )
    //     }
    // }
    // stage('Build') {
    //     steps {
    //         echo 'Checking Node and Npm version'
    //         sh '''
    //             ls -la
    //             node -v
    //             npm -v
    //         '''
    //         echo 'Installing dependencies and building the project'
    //         sh '''
    //             ls -la
    //         '''
    //     }
    // }
    }
    post {
        success {
            echo 'Build & Deployment Successful'
            setGitHubPullRequestStatus(context: 'Robot', message: 'Jenkins Success', state: 'SUCCESS')
        }
        failure {
            echo 'Build or Deployment Failed'
            setGitHubPullRequestStatus(context: 'Robot', message: 'Jenkins Failed', state: 'FAILURE')
        }
        always {
            // setGitHubPullRequestStatus(context: 'Robot', message: 'Jenkins Failed', state: 'FAILURE')
            cleanWs()
            echo 'Pipeline finished'
            echo "Build #${env.BUILD_NUMBER} ended"
        }
    }
}
