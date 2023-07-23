variable "ami" {
  description = "ami id"
  type        = string
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
}

variable "delete_on_termination" {
  description = "ec2 termination option"
  type        = bool
  default     = true
}

variable "encrypt_root_volume" {
  description = "ec2 encrypt root volume"
  type        = bool
  default     = false
}

variable "volume_size" {
  description = "ec2 volume size"
  type        = string
}

variable "volume_type" {
  description = "ec2 volume type"
  type        = string
}

variable "kms_key_arn" {
  description = "arn for kms key"
  type        = string
  default     = ""
}

variable "iops" {
  description = "value"
  type        = string
  default     = ""
}

variable "throughput" {
  description = "ec2 throughput"
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "id for secuirty groups"
  type        = list(string)
}

variable "subnet_id" {
  description = "subnet id"
  type        = string
}

variable "key_pair_name" {
  description = "ec2 key pair"
  type        = string
}

variable "ec2_tags" {
   description = "tags for ec2"
  type        = map(string)
}