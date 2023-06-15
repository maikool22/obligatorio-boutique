resource "aws_security_group" "oblimanual-sg" {
  name        = "test-terraform-sg"
  vpc_id      = aws_vpc.oblimanual.id # Revisar si puede funcionar asi
  description = "Permite SSH y HTTP"
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
    protocol    = "-1" # -1 significa todos los protocolos
    cidr_blocks = ["0.0.0.0/0"]
  }
}