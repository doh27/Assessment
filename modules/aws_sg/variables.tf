variable "sg_name" {
  description = "security group name"
  type        = string
}

variable "sg_desc" {
  description = "security group description"
  type        = string
}

variable "vpc_id" {
  description = "vpc ID"
  type        = string
}

variable "ingress_rules" {
  description = "Ingress rule for security group"
  type = map(object({
    description = string
    from_port   = string
    to_port     = string
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
  description = "egress rule for security group"
  type = map(object({
    description = string
    from_port   = string
    to_port     = string
    protocol    = string
    cidr_blocks = list(string)
  }))
}