resource "aws_autoscaling_group" "scaling" {
    capacity_rebalance        = true
    default_cooldown          = 300
    desired_capacity          = 1
    max_size                  = 5
    min_size                  = 1

    health_check_grace_period = 0
    health_check_type         = "EC2"
  
    launch_configuration      = aws_launch_configuration.scaling.id
    load_balancers            = []

    name                      = "${var.project_name}-${var.environment}"
    protect_from_scale_in     = false
    vpc_zone_identifier       =  var.subnets_id

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

    tag {
        key                 = "Name"
        propagate_at_launch = true
        value               = "${var.project_name}-${var.environment}"
    }

    lifecycle {
        ignore_changes = [
            desired_capacity
        ]
    }
}