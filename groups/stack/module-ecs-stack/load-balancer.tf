resource "aws_lb" "test-data-lb" {
  name            = "${var.stack_name}-${var.environment}-lb"
  security_groups = [aws_security_group.internal-service-sg.id]
  subnets         = flatten([split(",", var.subnet_ids)])
  internal        = var.test_data_lb_internal

  tags = {
    environment = var.environment
    Name        = "${var.name_prefix}-internal-service-sg"
    service     = "chs"
  }
}

resource "aws_lb_listener" "test-data-lb-listener" {
  load_balancer_arn = aws_lb.test-data-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_certificate_id
  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "test-data-generator-r53-record" {
  count   = var.zone_id == "" ? 0 : 1 # zone_id defaults to empty string giving count = 0 i.e. not route 53 record
  zone_id = var.zone_id
  name    = "test-data${var.external_top_level_domain}"
  type    = "A"
  alias {
    name                   = aws_lb.test-data-lb.dns_name
    zone_id                = aws_lb.test-data-lb.zone_id
    evaluate_target_health = false
  }
}
