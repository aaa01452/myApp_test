void setBuildStatus(String message, String state) {
  step([
      $class: "GitHubCommitStatusSetter",
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://github.com/my-org/my-repo"],
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "ci/jenkins/build-status"],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}


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
      stage('Start') {
            steps {
                script {
                    // Pipeline 一開始，設置 GitHub commit 狀態為 'pending'
                    setBuildStatus('Build started...', 'SUCCESS')
                }
            }
        }
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
            setBuildStatus("Build succeeded", "SUCCESS")
        }
        failure {
            echo 'Build or Deployment Failed'
            setBuildStatus("Build failed", "FAILURE")
        }
        always {
            cleanWs()
            echo 'Pipeline finished'
            echo "Build #${env.BUILD_NUMBER} ended"
        }
    }
}
