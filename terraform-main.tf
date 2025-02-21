provider "aws" {
  region = "us-east-1"  # Change as needed
}

resource "aws_security_group" "nginx_sg" {
  name_prefix = "nginx-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  ami           = "ami-0c55b159cbfafe1f0"  # Update based on region
  instance_type = "t2.micro"
  security_groups = [aws_security_group.nginx_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    echo "Deployed via Terraform" | sudo tee /var/www/html/index.html
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF

  tags = {
    Name = "nginx-server"
  }
}
