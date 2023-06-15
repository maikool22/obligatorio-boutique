# Creamos target group

resource "aws_lb_target_group" "oblimanual-trg" {
  name        = "oblimanual-trg"
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.oblimanual.id
}

resource "aws_alb_target_group_attachment" "oblimanual-tg-aws_alb_target_group_attach1" {
  target_group_arn = aws_lb_target_group.oblimanual-trg.arn
  target_id        = aws_instance.oblimanual-inst1.id
}

resource "aws_alb_target_group_attachment" "oblimanual-tg-aws_alb_target_group_attach2" {
  target_group_arn = aws_lb_target_group.oblimanual-trg.arn
  target_id        = aws_instance.oblimanual-inst2.id
}

resource "aws_lb" "obli-alb" {
  name               = "oblimanual-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.oblimanual-sg.id]
  subnets            = [aws_subnet.oblimanual-subnet1-publica.id, aws_subnet.oblimanual-subnet2-publica.id]
  # depends_on         = [aws_vpc.aws_vpc.oblimanual] # Se agrega dependencia para que el alb se cree luego del vpc
  enable_deletion_protection = false
  tags = {
    Environment = "prod"
  }
}

# Creamos Listener

resource "aws_lb_listener" "oblimanual-listener" {
  load_balancer_arn = aws_lb.obli-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.oblimanual-trg.arn
  }
}

### creamos la regla para el listener
resource "aws_lb_listener_rule" "oblimanual-listener-rule" {
  listener_arn = aws_lb_listener.oblimanual-listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.oblimanual-trg.arn
  }

  condition {
    path_pattern {
      values = ["/var/www/html/index.html"]
    }
  }
}