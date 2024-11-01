pipeline {
    agent any
    tools {
        nodejs 'node 18.20.4'
        git 'git'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('fe648b98-7b73-4e5a-85d1-2a71ad0487bb')
        NAME = 'myapp_test'
        IMAGE_REPO = 'ghcr.io/aaa01452'
        PACKAGE_NAME = "myApp_test"
        ORG_NAME = "aaa01452"
    }

    stages {
        stage('print env') {
            steps {
                sh 'printenv'
            }
        }

        stage('Show docker image ls') {
            steps {
                echo 'Show docker image ls'
                sh 'docker image ls'
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
                script {
                    echo 'Fetch Package Versions'
                    // 使用 GitHub API 抓取指定 package 的版本列表
                    // 使用 GitHub API 抓取指定 package 的版本列表
                    def response = sh(
                        script: """
                        curl -s -H "Authorization: Bearer $DOCKERHUB_CREDENTIALS" \
                        "https://api.github.com/users/$ORG_NAME/packages/container/$PACKAGE_NAME/versions"
                        """,
                        returnStdout: true
                    ).trim()
                    
                    // 輸出 JSON 回應，便於除錯
                    echo "GitHub API Response: ${response}"
                    
                    // 解析 JSON 結果
                    def versions = readJSON text: response
                    def versionParts = versions[0]?.metadata?.container?.tags[0].tokenize('.')
                    def latestVersion = "${versionParts[0]}.${versionParts[1].toInteger() + 1}"
                    echo "Latest version: ${latestVersion}"

                    echo 'Deliver for develop'
                    
                    sh 'docker image ls'
                    sh "docker build -t ${NAME}:latest ."
                    sh "docker tag ${NAME}:latest ${IMAGE_REPO}/${NAME}:${latestVersion}"
                    sh "echo $DOCKERHUB_CREDENTIALS | docker login ghcr.io -u aaa01452 --password-stdin"
                    sh "docker push ${IMAGE_REPO}/${NAME}:${latestVersion}"
                    sh 'docker image ls'
                    sh 'docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
                    sh "docker rmi ${IMAGE_REPO}/${NAME}:0.1"
                    sh "docker rmi ${IMAGE_REPO}/${NAME}:0.2"
                    sh "docker rmi ${IMAGE_REPO}/${NAME}:0.3"
                    sh "docker rmi ${IMAGE_REPO}/${NAME}:10-a8ed2212fbd5ea67fab02e0940cc249b211387ec"
                    sh "docker rmi ${IMAGE_REPO}/${NAME}:9-3ad9dbd745aa1af392a2b8d69d1bc4ad7b2cbe9e"
                    sh "docker rmi ${IMAGE_REPO}/${NAME}:${latestVersion}"
                    sh 'docker image ls'
                }
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