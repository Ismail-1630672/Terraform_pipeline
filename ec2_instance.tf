#VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.100.0.0/16"

    tags = {
        Name = "my_vpc"
    }

}

#Public subnets
resource "aws_subnet" "public1" {
    vpc_id = aws_vpc.my_vpc.id 
    cidr_block = "10.100.1.0/24"
    availability_zone = "eu-west-2a"

    tags = {
        Name = "public-subnet-1"
    }
}

#Internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "internet-gateway"
    }
}

#public route table
resource "aws_route_table" "publicrt" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "public-rt"
    }
}


#security group, controls inbound and outbound traffic out of instance based on rules
resource "aws_security_group" "allow_traffic" {
    vpc_id = aws_vpc.my_vpc.id
    name = "allow_traffic"
    description = "allow ssh and http traffic"

    #inbound rules, traffic coming into resource such as EC2 instance
    ingress {
        description = "Allow SSH" #ssh used to remotely connect to instances
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"] #allows traffic from anywhere on the internet

    }
    #allows anyone on the internet to access resource such as EC2 instance via port 22 using TCP

    ingress {
        description = "Allow HTTP"
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"] #allows traffic from anhwhere on the internet
    }
    #allows anyone on the internet to access resource such as EC2 instance via port 80 using TCP

    #outbound rules, controls traffic coming out of the resource such as EC2 instance
    egress {
        from_port = 0 #means all ports
        to_port = 0 #means all ports
        protocol = "-1" #means all protocols such as tcp, udp etc
        cidr_blocks = ["0.0.0.0/0"] #allow outbound traffic to any ipv4 address
        ipv6_cidr_blocks = ["::/0"] #allow outbound traffic to any ipv6 address

    }

    #this outbound rule allows the resource/instance to send traffic to anywhere on the internet whether ipv4 or ipv6

    tags = {
        Name = "Allow_ssh_and_http"
    }
}










resource "aws_instance" "ec2_instance" {
  ami           = "ami-07eb36e50da2fcccd"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public1.id
  security_groups = [aws_security_group.allow_traffic.id]

  tags = {
    Name = "ec2_instance"
  }
}