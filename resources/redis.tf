resource "aws_ebs_volume" "oblimanual-redis-ebs" {
  availability_zone = "us-east-1a"
  size              = 13
  tags = {
    Name = "oblimanual-redis-ebs"
  }
}


