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
    type = list
}

variable "vpc_id" {
    type = string
}

variable "subnets_id" {
    type = list
}

variable "alb_sg_id" {}