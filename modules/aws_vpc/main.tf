resource "aws_vpc" "this" {
  count = var.is_vpc_required ? 1 : 0

  cidr_block                           = var.vpc_cidr
  instance_tenancy                     = var.instance_tenancy
  enable_dns_support                   = var.enable_dns_support
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  tags = merge(
    var.vpc_tags,
    {
      Name = var.vpc_name

    }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  cidr_block                                     = var.public_subnet_cidrs[count.index]
  vpc_id                                         = aws_vpc.this[0].id
  availability_zone                              = element(var.azs, count.index)
  map_public_ip_on_launch                        = true
  enable_dns64                                   = var.enable_dns64
  enable_resource_name_dns_a_record_on_launch    = var.enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_resource_name_dns_aaaa_record_on_launch

  tags = merge(
    var.public_subnet_tags,
    {
      Name = format("%s %s - %d", var.vpc_name, "Public Subnet", count.index + 1)
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  cidr_block                                     = var.private_subnet_cidrs[count.index]
  vpc_id                                         = aws_vpc.this[0].id
  availability_zone                              = var.azs[count.index]
  map_public_ip_on_launch                        = false
  enable_dns64                                   = var.enable_dns64
  enable_resource_name_dns_a_record_on_launch    = var.enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_resource_name_dns_aaaa_record_on_launch

  tags = merge(
    var.private_subnet_tags,
    {
      Name = format("%s %s - %d", var.vpc_name, "Private Subnet", count.index + 1)
    }
  )
}

resource "aws_internet_gateway" "this" {
  count = length(var.public_subnet_cidrs) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id
  tags   = var.igw_tags
}


# ROUTE TABLES

resource "aws_route_table" "public" {
  count = length(var.public_subnet_cidrs) > 0 ? 1 : 0

  vpc_id           = aws_vpc.this[0].id
  propagating_vgws = var.public_propagating_vgws

  tags = merge(
    var.public_rt_tags,
    {
      Name = format("%s %s", var.vpc_name, "Public RT")
    }
  )
}

resource "aws_route" "internet_gw" {
  count = length(var.public_subnet_cidrs) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  route_table_id = aws_route_table.public[0].id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidrs) > 0 ? 1 : 0

  vpc_id           = aws_vpc.this[0].id
  propagating_vgws = var.private_propagating_vgws

  tags = merge(
    var.private_rt_tags,
    {
      Name = format("%s %s", var.vpc_name, "Private RT")
    }
  )
}

resource "aws_route" "nat_gw" {
  count = var.is_nat_gw_required ? 1 : 0

  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  route_table_id = aws_route_table.private[0].id
  subnet_id      = aws_subnet.private[count.index].id
}


# NAT GATEWAY
resource "aws_nat_gateway" "this" {
  count = var.is_nat_gw_required ? 1 : 0

  allocation_id     = var.connectivity_type == "public" ? aws_eip.this[0].id : ""
  connectivity_type = var.connectivity_type
  subnet_id         = aws_subnet.public[0].id

  tags = merge(
    var.nat_gw_tags,
    {
      Name = format("%s %s", var.vpc_name, "Natgateway")
    }
  )
}

resource "aws_eip" "this" {
  count = var.is_nat_gw_required && var.connectivity_type == "public" ? 1 : 0

  domain = "vpc"
}