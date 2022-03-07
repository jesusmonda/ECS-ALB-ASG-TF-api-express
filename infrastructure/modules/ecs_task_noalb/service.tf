resource "aws_ecs_service" "app" {
  cluster                            = var.ecs_cluster_arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1

  enable_execute_command            = true // exec command
  health_check_grace_period_seconds = 0
  name                              = "${var.project_name}-${var.environment}-${var.task_name}"
  scheduling_strategy               = "REPLICA"
  task_definition                   = "${aws_ecs_task_definition.app.family}:${aws_ecs_task_definition.app.revision}"

  capacity_provider_strategy {
    base              = 0
    capacity_provider = "${var.project_name}-${var.environment}-ecs-cp"
    weight            = 90
  }

  network_configuration {
    subnets         = var.subnets_id
    security_groups = [aws_security_group.app.id]
  }

  deployment_controller {
    type = "ECS"
  }

  service_registries {
    registry_arn = aws_service_discovery_service.app.arn
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}

resource "aws_security_group" "app" {
  name        = "${var.project_name}-${var.environment}-ecs-${var.task_name}"
  description = "${var.project_name}-${var.environment}-ecs-${var.task_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.api_users_sg_id] // Allow requests from api users
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-${var.task_name}"
  }
}