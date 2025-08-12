resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    { Name = "${var.name}-vpc" },
    var.common_tags,
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    { Name = "${var.name}-igw" },
    var.common_tags,
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    {
      Name                             = "${var.name}-public-${count.index}"
      "kubernetes.io/cluster/${var.name}" = "shared"
      "kubernetes.io/role/elb"              = "1"
    },
    var.common_tags,
  )
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    {
      Name                              = "${var.name}-private-${count.index}"
      "kubernetes.io/cluster/${var.name}" = "shared"
      "kubernetes.io/role/internal-elb"    = "1"
    },
    var.common_tags,
  )
}

resource "aws_eip" "nat" {
  count  = length(var.azs)
  domain = "vpc"

  tags = merge(
    {
      Name = "${var.name}-eip-${count.index}"
      "kubernetes.io/cluster/${var.name}" = "shared"
      "kubernetes.io/role/internal-elb"    = "1"
    },
    var.common_tags,
  )
}

resource "aws_nat_gateway" "natgw" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    {
      Name = "${var.name}-nat-${count.index}"
      "kubernetes.io/cluster/${var.name}" = "shared"
      "kubernetes.io/role/internal-elb"    = "1"
    },
    var.common_tags,
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name = "${var.name}-public-rt" },
    var.common_tags,
  )
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name = "${var.name}-private-rt-${count.index}" },
    var.common_tags,
  )
}

resource "aws_route" "private_nat" {
  count                  = length(var.azs)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
