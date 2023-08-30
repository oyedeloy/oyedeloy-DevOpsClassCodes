pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'
    }

    

    stages {
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Code Quality Check') {
            steps {
                sh 'mvn pmd:pmd'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package'
                archiveArtifacts artifacts: '**/target/*.war', allowEmptyArchive: true
            }
        }

        stage('apply') {
          environment {
            AWS_ACCESS_KEY_ID = credentials('ACCESS_KEY')
            AWS_SECRET_ACCESS_KEY = credentials('SECRET_KEY')
        }
       steps {
          sh 'terraform init'
          sh 'terraform plan'
          sh 'terraform apply -auto-approve'
          sh "ansible-playbook -i host1 try.yml --key-file '/home/ubuntu/mykeys2/Java_key.pem'"
         }
      }
    }
}
    

