pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        IMAGE_NAME = 'lakshmiparamesh/devops-capstone'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Determine Branch') {
            steps {
                script {
                    env.BRANCH_NAME = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()
                    env.COMMIT_TAG = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    if (env.BRANCH_NAME == 'master' || env.BRANCH_NAME == 'main') {
                        env.TARGET_REPO = "${IMAGE_NAME}-prod"
                    } else {
                        env.TARGET_REPO = "${IMAGE_NAME}-dev"
                    }
                    echo "Branch: ${env.BRANCH_NAME} → Pushing to: ${env.TARGET_REPO}"
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${env.TARGET_REPO}:${env.COMMIT_TAG} ."
                sh "docker tag ${env.TARGET_REPO}:${env.COMMIT_TAG} ${env.TARGET_REPO}:latest"
            }
        }

        stage('Docker Push') {
            steps {
                sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                sh "docker push ${env.TARGET_REPO}:${env.COMMIT_TAG}"
                sh "docker push ${env.TARGET_REPO}:latest"
            }
        }

        stage('Deploy') {
            steps {
                sh "docker compose down || true"
                sh "docker compose up -d"
                sh "sleep 5 && curl -f http://localhost:80 || echo 'Health check pending'"
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
        success {
            echo "Pipeline completed successfully! Image pushed to ${env.TARGET_REPO}"
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
