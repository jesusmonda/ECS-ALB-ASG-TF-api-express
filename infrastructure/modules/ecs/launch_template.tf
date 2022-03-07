locals {
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config;
EOF
}

resource "aws_launch_template" "nodes" {
  monitoring {
    enabled = true
  }
  disable_api_termination              = false
  image_id                             = "ami-0d8d8f76584c4a1ca"
  instance_type                        = "t2.micro"
  instance_initiated_shutdown_behavior = "terminate"
  name                                 = "${var.project_name}-${var.environment}-ecs-nodes"
  user_data                            = base64encode(local.user_data)

  instance_market_options {
    market_type = "spot"
    spot_options {
      block_duration_minutes = 0
      spot_instance_type     = "one-time"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.nodes.id] // To join ECS cluster and pull images docker
    // ASG assign subnets
  }

  ebs_optimized = false

  iam_instance_profile {
    arn = aws_iam_instance_profile.this.arn
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-${var.environment}-ecs-nodes"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      "Name" = "${var.project_name}-${var.environment}-ecs-nodes"
    }
  }
  tag_specifications {
    resource_type = "spot-instances-request"
    tags = {
      "Name" = "${var.project_name}-${var.environment}-ecs-nodes"
    }
  }
  tag_specifications {
    resource_type = "network-interface"
    tags = {
      "Name" = "${var.project_name}-${var.environment}-ecs-nodes"
    }
  }
}

resource "aws_security_group" "nodes" {
  name        = "${var.project_name}-${var.environment}-ecs-nodes"
  description = "${var.project_name}-${var.environment}-ecs-nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" // Request to join ECS Cluster and pull images docker
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-nodes"
  }
}