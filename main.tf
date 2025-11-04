# ------------------------------
# Terraform AWS EC2 Sandbox Demo
# ------------------------------

# Step 1: Specify the Terraform provider (AWS)
provider "aws" {
  region = "us-east-1" # You can change this to your preferred region
}

# Step 2: Create a security group to allow inbound HTTP traffic
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow inbound HTTP traffic"

  # Inbound rules (ingress): allow HTTP traffic on port 80 from anywhere
  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules (egress): allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# Step 3: Get the latest Amazon Linux 2 AMI automatically
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Only use official Amazon images
}

# Step 4: Launch an EC2 instance in the default subnet
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"  # Free tier eligible
  security_groups = [aws_security_group.web_sg.name]

  # Simple tag to help identify the instance
  tags = {
    Name = "Terraform-Web-Server"
  }
}
