# Security Group for EC2 allowing SSH and HTTP
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH from anywhere (change this in real environments)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 SG"
  }
}

# Use existing public key for SSH 
resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("${path.module}/my-key.pub")
}

# EC2 instance in public subnet
resource "aws_instance" "web_instance" {
  ami                         = "ami-0fab1b527ffa9b942" # Amazon Linux 2 - eu-west-1
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  key_name                    = aws_key_pair.my_key.key_name
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  # Install Nginx on boot
  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Welcome to Terraform Web Server</h1>" | sudo tee /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "Terraform-Web-Instance"
  }
}
