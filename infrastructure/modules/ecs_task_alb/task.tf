resource "aws_ecs_task_definition" "app" {
  family = "${var.project_name}-${var.environment}-${var.task_name}"
  // cpu                      = 200 // limit
  // memory                   = 200 // limit
  task_role_arn            = aws_iam_role.app.arn
  execution_role_arn       = var.execution_role_arn
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"

  // will be overwrite by github actions
  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = "null"
      // memory = 200 // limit
      memoryReservation = 100
      // cpu = 100 // reservation
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
    }
  ])

  lifecycle {
    ignore_changes = [container_definitions]
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name = "/ecs/${var.project_name}-${var.environment}-ecs-task-${var.task_name}"
}