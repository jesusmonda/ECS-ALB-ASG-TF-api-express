variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "zones" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

variable "subnets_id" {
  type = list(any)
}

variable "alb_sg_ids" {
  type = list(any)
}