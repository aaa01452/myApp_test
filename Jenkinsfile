pipeline {
    agent any
    triggers {
        githubPush()  // 使用 GitHub Webhook 直接觸發
    }
    stages {
        stage('Stage 1') {
            steps {
                echo 'Clone the repo'
                sh 'rm -fr myApp_test'
                sh 'git clone https://github.com/aaa01452/myApp_test.git'
            }
        }
        stage('Build Step 2') {
            when {
                changeRequest()  // 檢測 Pull Request
            }
            steps {
                echo 'Building pull request...'
                // 其他構建步驟
            }
        }
    }
}
