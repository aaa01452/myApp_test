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
        TEAM_WEBHOOK_URL = 'https://omnidevops.webhook.office.com/webhookb2/350628d1-bb9d-4bde-94af-c7c598b7bfd6@05da7c17-94ef-4892-8009-7aa9c7304945/JenkinsCI/febecb7875be49e1b4b07e64e28b4ea5/082534a2-df08-4fee-8ed4-90cef0c9bd35/V2ij276zqlHRseGVlzsRd_oU3Bj3P5T7Q0Jnf0WJ9PjRc1'
    }

    options {
        office365ConnectorWebhooks([[
            name: 'Office 365',
            startNotification: false,
            url: env.TEAM_WEBHOOK_URL
        ]])
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
                // some instructions here
                office365ConnectorSend webhookUrl: env.TEAM_WEBHOOK_URL,
                    adaptiveCards: true,
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
            office365ConnectorSend webhookUrl: env.TEAM_WEBHOOK_URL,
              message: 'Build & Deployment Successful',
              status: 'Success',
              adaptiveCards: true
        }
        failure {
            echo 'Build or Deployment Failed'
            office365ConnectorSend webhookUrl: env.TEAM_WEBHOOK_URL,
              message: 'Something went wrong',
              status: 'Failure',
              adaptiveCards: true
        }
    }
}
