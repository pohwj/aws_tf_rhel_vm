# Create a VPC
resource "aws_vpc" "rhel_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "rhel lab VPC"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "rhel_igw" {
  vpc_id = aws_vpc.rhel_vpc.id

  tags = {
    Name = "rhel lab IGW"
  }
}

# Create a Subnet
resource "aws_subnet" "rhel_subnet" {
  vpc_id     = aws_vpc.rhel_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "rhel lab Subnet"
  }
}

# Create a Route Table
resource "aws_route_table" "rhel_route_table" {
  vpc_id = aws_vpc.rhel_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rhel_igw.id
  }

  tags = {
    Name = "rhel lab Route Table"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "rhel_route_table_assoc" {
  subnet_id      = aws_subnet.rhel_subnet.id
  route_table_id = aws_route_table.rhel_route_table.id
}

# Create a Security Group
resource "aws_security_group" "rhel_sg" {
  name        = "rhel_sg"
  description = "Security group for rhel lab"
  vpc_id      = aws_vpc.rhel_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  # ingress {
    
  #     from_port   = 8080
  #     to_port     = 8080
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rhel lab Security Group"
  }
}

# Data source for the setup script
data "template_file" "user_data" {
  template = file("${path.module}/rhel_setup.sh")
}

# Create an EC2 Instance
data "aws_ami" "rhel_ami" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["RHEL-9.*"]
  }
}

resource "aws_instance" "rhel_instance" {
  ami           = data.aws_ami.rhel_ami.id
  instance_type = "t2.micro"
  count = 2 # 2 instances
  key_name = "ec2 tutorial" 
  

  vpc_security_group_ids = [aws_security_group.rhel_sg.id]
  subnet_id              = aws_subnet.rhel_subnet.id

  associate_public_ip_address = true

  user_data = data.template_file.user_data.rendered

  tags = {
    Name = "rhel lab instance ${count.index + 1}"
  }
}

# Output the public IP of the instance
output "rhel_instance_public_ip" {
  value = aws_instance.rhel_instance[*].public_ip
}