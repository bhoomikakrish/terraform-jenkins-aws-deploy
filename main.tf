provider "aws" {
  region = "ap-south-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "terraform-key" {
  key_name   = "terraform_key"
  public_key = file("C:/Users/bhoomika.krishnappa/.ssh/id_rsa.pub")
}

resource "aws_vpc" "demo" {
  cidr_block = var.cidr
}

resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo.id
}

resource "aws_subnet" "Demo_public_subnet" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "Demo_public_subnet_rt" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }
}

resource "aws_route_table_association" "demo_rt" {
  subnet_id      = aws_subnet.Demo_public_subnet.id
  route_table_id = aws_route_table.Demo_public_subnet_rt.id
}

resource "aws_security_group" "demo_sg" {
  vpc_id = aws_vpc.demo.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Enable SSH"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Enable HTTP"
  }

   ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Enable HTTP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Enable 8080 jenkins port"
  }
}

resource "aws_instance" "demo-ec2" {
  ami                    = "ami-00bb6a80f01f03502"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.terraform-key.key_name
  vpc_security_group_ids = [aws_security_group.demo_sg.id]
  subnet_id              = aws_subnet.Demo_public_subnet.id
  user_data = file("jenkins.sh")

  tags = {
    Name = "terraform_ec2_user"
  }
}
