variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "usermail" {
  description = "User's email for tagging and key management"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 Key Pair"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "storage_size" {
  description = "Size of the EBS volume in GB"
  type        = number
}

variable "quotahours" {
  description = "Total allowed running hours for the EC2 instance"
  type        = number
}

variable "hoursperday" {
  description = "Maximum allowed hours per day"
  type        = number
}

variable "category" {
  description = "Custom category for the instance"
  type        = string
}

variable "planstartdate" {
  description = "Start date of the EC2 plan in ISO format"
  type        = string
}
