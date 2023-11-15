pipeline {
    agent any

    environment {
        // Define Docker image and tag
        DOCKER_IMAGE = 'address-book'
        DOCKER_TAG = 'latest'
        // Define registry credentials ID
        DOCKER_CREDENTIALS_ID = 'Docker_hub'
    }

    stages {
        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Pulling Docker image
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
                        def app = docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}")

                        app.pull() // Optional: Pull the latest image for caching
                        
                        // Building Docker image
                        app.build("-f Dockerfile .")

                        // Pushing Docker image
                        app.push()
                    }
                }
            }
        }

        // Other stages like testing, deployment, etc., can go here
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
