
resource "aws_ecs_service" "ecs-stack-test-app2-ecs-service" {
  name            = "${var.environment}-ecs-stack-test-app2"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ecs-stack-test-app2-task-definition.arn
  desired_count   = 1
  depends_on      = [var.test-data-lb-arn]
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-stack-test-app2-target_group.arn
    container_port   = var.test2_application_port
    container_name   = "ecs-stack-test-app2"
  }
}

locals {
  ecs-stack-test-app2-definition = merge(
    {
      environment                     : var.environment
      name_prefix                     : var.name_prefix
      aws_region                      : var.aws_region
      external_top_level_domain       : var.external_top_level_domain
      log_level                       : var.log_level
      docker_registry                 : var.docker_registry
      release_version                 : var.test2_release_version
      application_port                : var.test2_application_port
    },
      var.secrets_arn_map
  )
}

resource "aws_ecs_task_definition" "ecs-stack-test-app2-task-definition" {
  family             = "${var.environment}-ecs-stack-test-app2"
  execution_role_arn = var.task_execution_role_arn
  container_definitions = templatefile(
    "${path.module}/ecs-stack-test-app2-task-definition.tmpl", local.ecs-stack-test-app2-definition
  )
}

resource "aws_lb_target_group" "ecs-stack-test-app2-target_group" {
  name                 = "${var.environment}-ecs-stack-test-app2-tg"
  port                 = var.test2_application_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 20

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/test2/healthcheck"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_lb_listener_rule" "ecs-stack-test-app2" {
  listener_arn = var.test-data-lb-listener-arn
  priority     = 2
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-stack-test-app2-target_group.arn
  }
  condition {
    field  = "path-pattern"
    values = ["/test2/*"]
  }
}
