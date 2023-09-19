provider "aws" {
  region = "us-east-2"
}
# We use local variables to simplify values that will be reused throuout the code
locals {
  ami_id          = "ami-00a9282ce3b5ddfb1"
  vpc_id          = "vpc-058d2f6e"
  ssh_user        = "ec2-user" 
  key_name        = "Java_key2"
  private_key_path = "/home/dele/Java_key2.pem"
  private_key_path2 = "/home/dele/mykeys/Java_key2.pem"
  inventory_path = "/home/dele/Inventory"  
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

  connection {
    type = "ssh"
    host = self.public_ip
    user = local.ssh_user
    private_key = file(local.private_key_path2)
    timeout = "4m"
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
    echo "${aws_instance.Java_web.public_ip}" > ${local.inventory_path}
  EOT
}

}

# Output the public IP address of the EC2 instance
output "public_ip" {
  value = aws_instance.Java_web.public_ip
}



