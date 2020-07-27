
resource "aws_ecs_service" "ecs-stack-test-app1-ecs-service" {
  name            = "${var.environment}-ecs-stack-test-app1"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ecs-stack-test-app1-task-definition.arn
  desired_count   = 1
  depends_on      = [var.test-data-lb-arn]
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-stack-test-app1-target_group.arn
    container_port   = var.test1_application_port
    container_name   = "ecs-stack-test-app1"
  }
}

locals {
  ecs-stack-test-app1-definition = merge(
    {
      environment                     : var.environment
      name_prefix                     : var.name_prefix
      aws_region                      : var.aws_region
      external_top_level_domain       : var.external_top_level_domain
      log_level                       : var.log_level
      docker_registry                 : var.docker_registry
      release_version                 : var.test1_release_version
      application_port                : var.test1_application_port
    },
      var.secrets_arn_map
  )
}

resource "aws_ecs_task_definition" "ecs-stack-test-app1-task-definition" {
  family             = "${var.environment}-ecs-stack-test-app1"
  execution_role_arn = var.task_execution_role_arn
  container_definitions = templatefile(
    "${path.module}/ecs-stack-test-app1-task-definition.tmpl", local.ecs-stack-test-app1-definition
  )
}

resource "aws_lb_target_group" "ecs-stack-test-app1-target_group" {
  name     = "${var.environment}-ecs-stack-test-app1-tg"
  port     = var.test1_application_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/test1/healthcheck"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_lb_listener_rule" "ecs-stack-test-app1" {
  listener_arn = var.test-data-lb-listener-arn
  priority     = 3
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-stack-test-app1-target_group.arn
  }
  condition {
    field  = "path-pattern"
    values = ["/test1/*"]
  }
}
