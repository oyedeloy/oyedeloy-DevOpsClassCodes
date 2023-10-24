pipeline {
    agent any

    stages {
        stage('Git Checkout') {
            steps {
                // Checkout your source code from the Git repository
                // Replace the URL with your Git repository URL and specify the branch
                script {
                    checkout([$class: 'GitSCM', branches: [[name: 'master']], userRemoteConfigs: [[url: 'https://github.com/oyedeloy/oyedeloy-DevOpsClassCodes.git']]])
                }
            }
        }
    }

    post {
        success {
            echo 'Git checkout completed successfully.'
        }
        failure {
            echo 'Git checkout failed.'
        }
    }
}