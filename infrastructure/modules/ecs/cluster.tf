resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

}

resource "aws_ecs_cluster_capacity_providers" "cp" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = [aws_ecs_capacity_provider.cp.name]

  default_capacity_provider_strategy {
    base              = 0  // Min launched tasks 
    weight            = 90 // Percentage of the total number of launched tasks that should use the specified capacity provider
    capacity_provider = aws_ecs_capacity_provider.cp.name
  }
}

resource "aws_ecs_capacity_provider" "cp" {
  name = "${var.project_name}-${var.environment}-ecs-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.scaling.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      instance_warmup_period = 300
      status                 = "ENABLED"
      target_capacity        = 80 // Instance capacity, % to scale out
    }
  }
}