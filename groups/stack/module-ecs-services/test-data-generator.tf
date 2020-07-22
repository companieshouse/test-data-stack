locals {
  service_name = "test-data-generator"
}

resource "aws_ecs_service" "test-data-generator-ecs-service" {
  name            = "${var.environment}-${local.service_name}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.test-data-generator-task-definition.arn
  desired_count   = 1

  depends_on = [
    "aws_lb_target_group.test-data-generator-target_group",
    "aws_lb.test-data-generator-lb"
  ]

  load_balancer {
    target_group_arn = aws_lb_target_group.test-data-generator-target_group.arn
    container_port   = var.application_port
    container_name   = local.service_name
  }
}

locals {
  definition = merge(
    {
      environment                     : var.environment
      name_prefix                     : var.name_prefix
      aws_region                      : var.aws_region
      external_top_level_domain       : var.external_top_level_domain
      log_level                       : var.log_level
      docker_registry                 : var.docker_registry
      release_version                 : var.release_version
      application_port                : var.application_port
    },
      var.secrets_arn_map
  )
}

resource "aws_ecs_task_definition" "test-data-generator-task-definition" {
  family             = "${var.environment}-${local.service_name}"
  execution_role_arn = var.task_execution_role_arn

  container_definitions = templatefile(
    "${path.module}/${local.service_name}-task-definition.tmpl", local.definition
  )
}

resource "aws_lb_target_group" "test-data-generator-target_group" {
  name     = "${var.environment}-${local.service_name}"
  port     = var.application_port
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

    type             = "forward"
    target_group_arn = aws_lb_target_group.test-data-generator-target_group.arn
  }

  }
}
