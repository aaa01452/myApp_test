pipeline {
    agent any
    tools {
        // nodejs 'node 18.20.4'
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
                echo 'Delete Images'
                sh "docker rmi ghcr.io/ethan-omniway/nginx:0.1"
                sh "docker rmi ghcr.io/ethan-omniway/nginx:latest"
                sh "docker rmi ghcr.io/ethan-omniway/random-image:dfc23dfa-eb2b-465e-9499-4bb4b2716609"
                echo 'Show docker image ls part 2'
                sh 'docker image ls'
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
                    def versionParts
                    if (versions[0]?.metadata?.container?.tags[0] == 'latest') {
                        versionParts = versions[0]?.metadata?.container?.tags[1].tokenize('.')
                    } else {
                        versionParts = versions[0]?.metadata?.container?.tags[0].tokenize('.')
                    }
                    def latestVersion = "${versionParts[0]}.${versionParts[1].toInteger() + 1}"
                    echo "Latest version: ${latestVersion}"

                    echo 'Deliver for develop'

                    sh 'docker image'
                    sh "docker build -t ${NAME}:${latestVersion} ."
                    sh "docker tag ${NAME}:${latestVersion} ${IMAGE_REPO}/${NAME}:${latestVersion}"
                    sh "docker tag ${NAME}:${latestVersion} ${IMAGE_REPO}/${NAME}:latest"
                    sh 'docker image ls'
                    sh "echo $DOCKERHUB_CREDENTIALS | docker login ghcr.io -u aaa01452 --password-stdin"
                    sh "docker push ${IMAGE_REPO}/${NAME}:${latestVersion}"
                    sh "docker push ${IMAGE_REPO}/${NAME}:latest"
                    
                    echo 'List Docker Images'
                    sh 'docker image ls'
                    
                    echo 'Clean Docker Images'
                    sh 'docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
                    sh "docker rmi ${IMAGE_REPO}/${NAME}:${latestVersion}"
                    sh "docker rmi ${IMAGE_REPO}/${NAME}:latest"
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