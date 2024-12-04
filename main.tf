provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "nginx-server" {
  ami           = "ami-0453ec754f44f9a4a" # Amazon Linux AMI for your region
  instance_type = "t2.micro"

  tags = {
    Name        = "Upb-Nginx"
    Environment = "test"
    Owner       = "abrendakhenya@gmail.com"
    Team        = "DevOps"
    Project     = "webinar"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Install Nginx
              sudo yum install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx

              # Create a directory for the website
              sudo mkdir -p /usr/share/nginx/html
              EOF

  key_name = aws_key_pair.nginx-server-ssh.key_name
  vpc_security_group_ids = [aws_security_group.nginx-server-sg.id]

  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("nginx-server.key")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "style.css"
    destination = "/tmp/style.css"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("nginx-server.key")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "script.js"
    destination = "/tmp/script.js"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("nginx-server.key")
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /usr/share/nginx/html",
      "sudo rm -f /usr/share/nginx/html/index.html",
      "sudo mv /tmp/index.html /usr/share/nginx/html/",
      "sudo mv /tmp/style.css /usr/share/nginx/html/",
      "sudo mv /tmp/script.js /usr/share/nginx/html/",
      "sudo chmod -R 755 /usr/share/nginx/html/"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("nginx-server.key")
      host        = self.public_ip
    }
  }
}

resource "aws_key_pair" "nginx-server-ssh" {
  key_name   = "nginx-server-ssh"
  public_key = file("nginx-server.key.pub")
}

resource "aws_security_group" "nginx-server-sg" {
  name        = "nginx-server-sg"
  description = "Security group allowing SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
