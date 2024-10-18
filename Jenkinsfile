pipeline {
    agent any
    stages {
        stage('Stage 1') {
            steps {
                echo 'Clone the repo'
                sh 'rm -fr myApp_test'
                sh 'git clone https://github.com/aaa01452/myApp_test.git'
            }
        }
    }
}
