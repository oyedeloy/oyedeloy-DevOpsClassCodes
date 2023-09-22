pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'
    }

    

    stages {        

        stage('apply') {
          environment {
            AWS_ACCESS_KEY_ID = credentials('ACCESS_KEY')
            AWS_SECRET_ACCESS_KEY = credentials('SECRET_KEY')
        }
       steps {
          sh 'terraform init'
          sh 'terraform plan'
          sh 'terraform apply -auto-approve'
          
         }
      }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    // Add your SSH key credential here for Ansible
                    sshagent(credentials: ['ec2-user']) {
                        sh 'sudo ansible-playbook -i /home/dele/Inventory --user ec2-user --private-key /home/dele/Java_key2.pem config.yml --ask-vault-pass'
                    }
                }
            }
        }

    }
}



