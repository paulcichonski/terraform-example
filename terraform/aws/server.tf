variable "server_image_type" { default = "t2.micro" }
variable "server_key_name" { description = "aws keypair to place on server instance" }

resource "aws_instance" "server" {
  ami = "${var.coreos_stable_hvm_ami}"
  instance_type = "${var.server_image_type}"
  vpc_security_group_ids  = [ "${aws_security_group.server.id}" ]
  subnet_id = "${aws_subnet.public_a.id}"
  key_name = "${var.server_key_name}"

  user_data = "${file("${path.root}/resources/cloud-config/server.yaml")}"

  tags {
    Name = "${var.infra_name}-server"
    Infra = "${var.infra_name}"
  }
}

resource "aws_security_group" "server"  {
  vpc_id = "${aws_vpc.main.id}"
  description = "server"

  # Allow SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow http
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ## allow 443 for coreos update engine
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ## ntp
  egress {
    from_port = 123
    to_port = 123
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.infra_name}-server"
    Infra = "${var.infra_name}"
  }
}

output "server_public_eip" {
  value = "${aws_instance.server.public_ip}"
}
