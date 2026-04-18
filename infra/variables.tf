variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix for all resources"
  type        = string
  default     = "pdc-donuts"
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "pdcadmin"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "pdcdb"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 8080
}
