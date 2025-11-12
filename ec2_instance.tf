resource "aws_instance" "ec2_instance" {
  ami           = "ami-07eb36e50da2fcccd"
  instance_type = "t3.micro"

  tags = {
    Name = "ec2_instance"
  }
}