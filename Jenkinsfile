pipeline {
    agent any

    stages {
        stage('Git Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM', branches: [[name: 'main']], userRemoteConfigs: [[url: 'https://github.com/oyedeloy/oyedeloy-DevOpsClassCodes.git']]])
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    def dockerImage = 'Address_book'
                    def dockerTag = 'Version-001'

                    // Log in to Docker Hub using Jenkins credentials
                    withCredentials([usernamePassword(credentialsId: 'Docker_hub', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        sh "docker build -t ${dockerImage}:${dockerTag} -f Dockerfile ."
                        sh "docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD"
                        sh "docker push ${dockerImage}:${dockerTag}"
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image build and push to Docker Hub completed successfully.'
        }
        failure {
            echo 'Docker image build and push to Docker Hub failed.'
        }
    }
}