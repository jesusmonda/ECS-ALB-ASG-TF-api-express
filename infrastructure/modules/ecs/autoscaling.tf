resource "aws_autoscaling_group" "scaling" {
  capacity_rebalance = true
  default_cooldown   = 300
  desired_capacity   = 3
  max_size           = 4
  min_size           = 3 // High availability

  health_check_grace_period = 0
  health_check_type         = "EC2"

  launch_template {
    id      = aws_launch_template.nodes.id
    version = "$Latest"
  }

  load_balancers = []

  name                  = "${var.project_name}-${var.environment}"
  protect_from_scale_in = false
  vpc_zone_identifier   = var.subnets_id

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${var.project_name}-${var.environment}-ecs-nodes"
  }

  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }
}