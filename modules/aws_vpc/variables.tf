variable "is_vpc_required" {
  description = "Specifies whether the VPC to be created or not. possible values true or false"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
}

variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string
}

variable "instance_tenancy" {
  description = "Instance_tenancy"
  type        = string
  default     = "default"
}

variable "enable_dns_support" {
  description = "This will allows dns resolution"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "This will enable dns hostname"
  type        = bool
  default     = false
}

variable "enable_network_address_usage_metrics" {
  description = "identifies the cost that's associated with using that route"
  type        = bool
  default     = false
}

variable "vpc_tags" {
  description = "vpc tags"
  type        = map(string)
}

# Subnet Variables

variable "public_subnet_cidrs" {
  description = "public subnet cidr"
  type        = list(string)
}

variable "azs" {
  description = "availability zones"
  type        = list(string)
}

variable "enable_dns64" {
  description = "This will enable  AAAA records"
  type        = bool
  default     = false
}

variable "enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records"
  type        = bool
  default     = false
}

variable "enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A record"
  type        = bool
  default     = false
}

variable "public_subnet_tags" {
  description = "public subnet tags"
  type        = map(string)
}

variable "private_subnet_cidrs" {
  description = "private subnet cidrs"
  type        = list(string)
}

variable "private_subnet_tags" {
  description = "private subnet tags"
  type        = map(string)
}

variable "igw_tags" {
  description = "igw tags"
  type        = map(string)
  default     = {}
}

# RouteTable Variables
variable "public_rt_tags" {
  description = "tags for public routes"
  type        = map(string)
  default     = {}
}

variable "public_propagating_vgws" {
  description = "A map of tags to apply to the public route table(s)"
  type        = list(string)
  default     = []
}

variable "private_rt_tags" {
  description = "tags for private route"
  type        = map(string)
  default     = {}
}

variable "private_propagating_vgws" {
  description = "A map of tags to apply to the private route table(s), on top of the # custom_tags. "
  type        = list(string)
  default     = []
}

# NAT GATEWAY

variable "connectivity_type" {
  description = "to connect to the internet "
  type        = string
  default     = "public"
}

variable "is_nat_gw_required" {
  description = "Specifies whether the VPC to be created or not. possible values true or false"
  type        = bool
  default     = false
}

variable "nat_gw_tags" {
  description = "tags for nat gateway"
  type        = map(string)
  default     = {}
}