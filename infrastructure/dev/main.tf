module "ecs" {
    source = "../modules/ecs"

    environment = "dev"
    region = "eu-west-1"
    project_name = "jesusmonda"
    zones = [
        "eu-west-1a",
        "eu-west-1b",
        "eu-west-1c",
    ]
    vpc_id = "vpc-079f0f3a2611e36f1"
    subnets_id = [
        "subnet-0789a8e79ec2ebb4c",
        "subnet-0a594e02d45a79d85",
        "subnet-0f76b6e5f96533dc5",
    ]
    alb_sg_id = module.task_api.alb_sg_id
}

module "task_api" {
    source = "../modules/ecs_task"

    environment = "dev"
    region = "eu-west-1"
    project_name = "jesusmonda"
    execution_role_arn = module.ecs.execution_role_arn
    vpc_id = "vpc-079f0f3a2611e36f1"
    subnets_id = [
        "subnet-0789a8e79ec2ebb4c",
        "subnet-0a594e02d45a79d85",
        "subnet-0f76b6e5f96533dc5",
    ]
    ecs_cluster_arn = module.ecs.cluster_arn

    task_name = "eeeeeeeeue"
    container_name = "api"
    container_port = 3000
    health_path = "/health"
}