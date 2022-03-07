variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "ecs_cluster_arn" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets_id" {
  type = list(string)
}

variable "task_name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_port" {
  type = number
}

variable "health_path" {
  type = string
}

variable "api_users_sg_id" {
  type = string
}