resource "aws_launch_configuration" "scaling" {
    associate_public_ip_address      = false
    ebs_optimized                    = false
    enable_monitoring                = true
    iam_instance_profile             = aws_iam_instance_profile.this.arn
    image_id                         = "ami-0d8d8f76584c4a1ca"
    instance_type                    = "t2.medium"
    name                             = "${var.project_name}-${var.environment}-ecs-nodes"
    security_groups                  = [aws_security_group.scaling.id]
    user_data                        = <<EOF
    #!/bin/bash
    echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config;
    EOF

    root_block_device {
        delete_on_termination = false
        encrypted             = true
        volume_size           = 30
        volume_type           = "gp2"
    }
}

resource "aws_security_group" "scaling" {
  name        = "${var.project_name}-${var.environment}-ecs-nodes"
  description = "${var.project_name}-${var.environment}-ecs-nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups = [var.alb_sg_id]
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