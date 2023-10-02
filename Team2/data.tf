data "terraform_remote_state" "main" {
  backend = "s3"
  config = {
    bucket             = "bucket-for-s3backendmaverick"     # create s3 in aws
    #dynamodb_table = "state-lock"                            # create dynamo table in aws
    key                = "global/mystatefile/terraform.tfstate"
    region             = "eu-west-1"
    encrypt            = true
  }
}

output "full_list" {
  value = data.terraform_remote_state.main.outputs.*
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = data.terraform_remote_state.main.outputs.public_subnets[0]

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.terraform_remote_state.main.outputs.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}