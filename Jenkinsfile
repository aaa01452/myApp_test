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
        PACKAGE_NAME = 'myApp_test'
        ORG_NAME = 'aaa01452'
        // TEAM_WEBHOOK_URL = 'https://prod-18.southeastasia.logic.azure.com:443/workflows/3e5e0c2423ba4cfbb34af65cbedbf872/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=iBJrP1HXc-F2NW27BmqvgsUJS-nkOKMrOlRszExFEjk'
        // TEAM_WEBHOOK_URL = credentials('2cffeca5-e485-4e03-a8dd-f0cc8954bf4e')
        TEAM_WEBHOOK_URL = env.LETCRM_TEAM_WEBHOOK_URL
    }

    // options {
    //     office365ConnectorWebhooks([[
    //         name: 'Office 365',
    //         startNotification: true,
    //         url: TEAM_WEBHOOK_URL
    //     ]])
    // }

    stages {
        stage('print env') {
            steps {
                sh "curl -X POST -H 'Content-Type: application/json' -d '{\"text\": \"Hello, Jenkins!\"}' $TEAM_WEBHOOK_URL"
                sh 'printenv'
            }
        }

        stage('Show docker image ls') {
            steps {
                echo 'Show docker image ls'
                sh 'docker image ls'
                // some instructions here
                office365ConnectorSend webhookUrl: $TEAM_WEBHOOK_URL,
                    message: 'Show jenkins team card'
            }
        }

        stage('Deliver for develop') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    echo 'Send notification to Teams'
                    office365ConnectorSend webhookUrl: env.TEAM_WEBHOOK_URL,
                    message: 'Ready to deploy',

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
    post {
        always {
            cleanWs()
            echo 'Pipeline finished'
        }
        success {
            echo 'Build & Deployment Successful'
            // office365ConnectorSend webhookUrl: env.TEAM_WEBHOOK_URL,
            //   message: 'Build & Deployment Successful',
            //   status: 'Success'
        }
        failure {
            echo 'Build or Deployment Failed'
            // office365ConnectorSend webhookUrl: env.TEAM_WEBHOOK_URL,
            //   message: 'Something went wrong',
            //   status: 'Failure'
        }
    }
}
