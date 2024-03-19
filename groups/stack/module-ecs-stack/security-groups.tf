resource "aws_security_group" "internal-service-sg" {
  description = "Security group for internal service albs"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
    Name        = "${var.name_prefix}-internal-service-sg"
  }
}

resource "aws_security_group_rule" "web_http" {
  for_each = toset(var.web_access_cidrs)

  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.internal-service-sg.id
}

resource "aws_security_group_rule" "web_https" {
  for_each = toset(var.web_access_cidrs)

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.internal-service-sg.id
}

resource "aws_security_group_rule" "concourse_http" {
  for_each = toset(var.concourse_access_cidrs)

  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.internal-service-sg.id
}

resource "aws_security_group_rule" "concourse_https" {
  for_each = toset(var.concourse_access_cidrs)

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.internal-service-sg.id
}
