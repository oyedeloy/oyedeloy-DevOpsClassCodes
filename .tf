

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

  connection {
    type        = "ssh"
    user        = local.ssh_user
    #private_key = file(local.private_key_path2)
    host        = self.public_ip
  }




   # Local-exec provisioner to save the public IP to a file
resource "null_resource" "save_ip" {
  triggers = {
    instance_id = aws_instance.example.id
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > myhosts.txt"
  }
}



  provisioner "local-exec" {
    command = "ansible-playbook -i myhosts.txt config.yml --key-file '/home/ubuntu/mykeys2/Java_key.pem'"
  }

}