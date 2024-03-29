resource "aws_service_discovery_private_dns_namespace" "app" { // Hosted zone
  name = "${var.project_name}.${var.environment}"
  vpc  = var.vpc_id
}

resource "aws_service_discovery_service" "app" {
  name = var.task_name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.app.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}