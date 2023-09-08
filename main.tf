provider "aws" {
  region = "us-east-2"
}

locals {
  ami_id          = "ami-024e6efaf93d85776"
  vpc_id          = "vpc-058d2f6e"
  ssh_user        = "ubuntu"
  key_name        = "Java_key"
  private_key_path = "/home/ubuntu/mykeys/Java_key.pem"
  private_key_path2 = "/home/ubuntu/mykeys2/Java_key.pem"
}

resource "aws_security_group" "Java_proj" {
  name_prefix = "Java_proj"
  vpc_id      = local.vpc_id

  // Ingress rules
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Java_web" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  key_name      = local.key_name
  associate_public_ip_address = true
  #  vpc_id     = local.vpc_id
  security_groups = [aws_security_group.Java_proj.name]
  
  
  tags = {
    Name = "Java test"
     }


# Use a local-exec provisioner to run an Ansible playbook
provisioner "local-exec" {
  command = <<EOT
    
    export ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no"
  EOT
}
# Use a local-exec provisioner to export the public IP to a file
provisioner "local-exec" {
  command = <<-EOT
    echo "${aws_instance.Java_web.public_ip}" > public_ip.txt
  EOT
}

# Use a file provisioner to copy the public IP file to a local directory
provisioner "file" {
  source      = "public_ip.txt"
  destination = "${path.module}inventory.txt"
}


}

# Output the public IP address of the EC2 instance
output "public_ip" {
  value = aws_instance.Java_web.public_ip
}
     
  
  
 
  



/*resource "null_resource" "run_ansible" {
  depends_on = [aws_instance.Java_web]

  provisioner "local-exec" {
    command = "ansible-playbook -i host1 try.yml --user=ubuntu --key-file '/home/ubuntu/mykeys2/Java_key.pem'"
  }
}*/






  




