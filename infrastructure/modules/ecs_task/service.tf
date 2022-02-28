// service role to describe ALB

resource "aws_ecs_service" "app" {
    cluster                            = var.ecs_cluster_arn
    deployment_maximum_percent         = 200
    deployment_minimum_healthy_percent = 100
    desired_count                      = 1

    enable_execute_command             = true // exec command
    health_check_grace_period_seconds  = 0
    iam_role                           = aws_iam_role.service.arn
    name                               = "${var.project_name}-${var.environment}-${var.task_name}"
    scheduling_strategy                = "REPLICA"
    task_definition                    = "${aws_ecs_task_definition.app.family}:1"

capacity_provider_strategy {
          base              = 0
          capacity_provider = "${var.project_name}-${var.environment}-ecs-cp"
          weight            = 90
      }

    deployment_controller {
        type = "ECS"
    }

    load_balancer {
        container_name   = var.container_name
        container_port   = var.container_port
        target_group_arn = aws_lb_target_group.app.arn
    }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}

resource "aws_iam_role_policy_attachment" "service" {
  role       = aws_iam_role.service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role" "service" {
  name = "${var.project_name}-${var.environment}-ecs-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
  })
}