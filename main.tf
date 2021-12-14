provider "aws" {
	region  = "us-west-2"
}

variable "TFC_WORKSPACE_NAME" {
  type = string
  default = ""
}

locals {
	web_instance_type_map = {
		stage = "t2.micro"
		prod = "t2.large"
	}
	web_instance_count_map = {
		stage = 1
		prod = 2
	}
	instances = {
		"t3.micro" = data.aws_ami.myUbuntu.id
		"t3.large" = data.aws_ami.myUbuntu.id
	}

	workspace = var.TFC_WORKSPACE_NAME != "" ? var.TFC_WORKSPACE_NAME : terraform.workspace
}

data "aws_ami" "myUbuntu" {
	most_recent = true

	filter {
		name   = "name"
		values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
	}

	filter {
		name   = "virtualization-type"
		values = ["hvm"]
	}

	owners = ["099720109477"]
}

resource "aws_instance" "myInstance" {
	ami           = data.aws_ami.myUbuntu.id
	instance_type = local.web_instance_type_map[local.workspace]
	availability_zone = "us-west-2a"
	count = local.web_instance_count_map[local.workspace]
	lifecycle {
		create_before_destroy = true
	}

	tags = {
		Name = "HelloWorldaaaa"
	}
}

resource "aws_instance" "myInstance1" {
	for_each = local.instances

	ami           = each.value
	instance_type = each.key
	availability_zone = "us-west-2a"

	tags = {
		Name = "HelloWorld_each"
	}
}