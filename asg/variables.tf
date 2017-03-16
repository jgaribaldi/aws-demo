variable "access_key" {
  type = "string"
  description = "The AWS access key"
}

variable "secret_key" {
  type = "string"
  description = "The AWS access secret"
}

variable "security_groups" {
  type = "list"
  description = "Security groups to apply to instances"
}

variable "availability_zones" {
  type = "list"
  description = "Availability zones for the instances"
}
