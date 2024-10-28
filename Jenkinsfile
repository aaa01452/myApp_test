pipeline {
    agent any
    tools {
        nodejs 'node 18.20.4'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('fe648b98-7b73-4e5a-85d1-2a71ad0487bb')
        // VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
        VERSION = "0.1"
        NAME = "myapp_test"
        IMAGE = "${NAME}:${VERSION}"
        IMAGE_REPO = "ghcr.io/aaa01452"
    }

    stages {
        stage('print env') {
            steps {
                sh 'printenv'
            }
        }
        stage('Get First Tag') {
            steps {
                echo "Get First Tag"
                script {
                    sh 'ls -al'
                    sh 'chmod +x jenkins/image_version.sh'
                    // 執行外部 shell 腳本，捕捉輸出並將其設為 Jenkins 環境變數
                    def tag_value = sh(
                        script: 'jenkins/image_version.sh',
                        returnStdout: true
                    ).trim()

                    // 設定 Jenkins 環境變數
                    env.FIRST_TAG = tag_value

                    // 印出結果 (可選)
                    echo "The first tag is: ${env.FIRST_TAG}"
                }
            }
        }
        stage('Build') {
            steps {
                echo 'step 1'
                sh 'node -v'
            }
        }
        stage('Test') {
            steps {
                echo 'step 2'
            }
        }
        stage('Run Unit Test') {
            when {
                not {
                    anyOf {
                        branch 'main'
                        branch 'develop'
                    }
                }
            }
            steps {
                echo 'Run Unit Test'
            }
        }
        stage('Deliver for develop') {
            when {
                branch 'develop'
            }
            steps {
                echo "Deliver for ${env.BRANCH_NAME}"
                sh "docker build -t ${NAME} ."
                sh 'docker image ls'
                // sh 'docker tag myapp_test:latest ghcr.io/aaa01452/myapp_test:latest'
                sh "docker tag ${NAME}:latest ${IMAGE_REPO}/${NAME}:${VERSION}"
                sh 'echo $DOCKERHUB_CREDENTIALS | docker login ghcr.io -u aaa01452 --password-stdin'
                sh "docker push ${IMAGE_REPO}/${NAME}:${VERSION}"
                sh "docker rmi ${IMAGE_REPO}/${NAME}:${VERSION}"
            }
        }
        stage('Deliver for main') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deliver for main'
            }
        }
    }
}
