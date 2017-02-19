resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.infra_name}-vpc"
    Infra = "${var.infra_name}"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.public_subnet_a_cidr}"
  availability_zone = "${var.public_subnet_a_az}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.infra_name}-public_subnet_a"
    Infra = "${var.infra_name}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.infra_name}-internet-gw"
    Infra = "${var.infra_name}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "${var.infra_name}-public-route-table"
    Infra = "${var.infra_name}"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id = "${aws_subnet.public_a.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}
output "vpc_cidr" {
  value = "${var.vpc_cidr}"
}
output "infra_name" {
  value = "${var.infra_name}"
}
output "public_subnet_a_id" {
  value = "${aws_subnet.public_a.id}"
}
