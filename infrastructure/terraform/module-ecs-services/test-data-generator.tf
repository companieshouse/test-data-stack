
resource "aws_ecs_service" "test-data-generator-ecs-service" {
  name            = "${var.environment}-test-data-generator"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.test-data-generator-task-definition.arn
  desired_count   = 1

  depends_on = [
    "aws_lb_target_group.test-data-generator-target_group",
    "aws_lb.test-data-generator-lb"
  ]

  load_balancer {
    target_group_arn = aws_lb_target_group.test-data-generator-target_group.arn
    container_port   = var.docker_container_port
    container_name   = "test-data-generator"
  }
}

locals {
  definition = merge(
    {
      environment                     : var.environment
      name_prefix                     : var.name_prefix
      aws_region                      : var.aws_region
      top_level_domain                : var.top_level_domain
      log_level                       : var.log_level
      docker_registry                 : var.docker_registry
      app_version_test_data_generator : var.app_version_test_data_generator
      docker_container_port           : var.docker_container_port
    },
      var.secrets_arn_map
  )
}

resource "aws_ecs_task_definition" "test-data-generator-task-definition" {
  family             = "${var.environment}-test-data-generator"
  execution_role_arn = var.task_execution_role_arn

  container_definitions = templatefile(
    "${path.module}/test-data-generator-task-definition.tmpl", local.definition
  )
}

resource "aws_lb_target_group" "test-data-generator-target_group" {
  name     = "${var.environment}-test-data-generator"
  port     = var.docker_container_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/test-data/healthcheck"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_lb" "test-data-generator-lb" {
  name            = "test-data-generator-${var.environment}-lb"
  security_groups = [aws_security_group.internal-service-sg.id]
  subnets         = flatten([split(",", var.application_ids)])
  internal        = true
}

resource "aws_lb_listener" "test-data-generator-lb-listener" {
  load_balancer_arn = aws_lb.test-data-generator-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_certificate_id

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test-data-generator-target_group.arn
  }
}

resource "aws_route53_record" "test-data-generator-r53-record" {
  count   = "${var.zone_id == "" ? 0 : 1}" # zone_id defaults to empty string giving count = 0 i.e. not route 53 record

  zone_id = var.zone_id
  name    = "test-data${var.top_level_domain}"
  type    = "A"
  alias {
    name                   = aws_lb.test-data-generator-lb.dns_name
    zone_id                = aws_lb.test-data-generator-lb.zone_id
    evaluate_target_health = false
  }
}
