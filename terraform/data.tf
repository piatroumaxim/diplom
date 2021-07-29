data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_vpc" "ecs-vpc" {
  tags = {
    project = "diplom"
  }
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.ecs-vpc.id
}

data "aws_instance" "db" {
  instance_tags = {
    project = "diplom"
    Name = "db"
  }
}

data "aws_ecr_repository" "api" {
  name = "api"
}

data "aws_ecr_repository" "bcknd" {
  name = "bcknd"
}

data "aws_ecr_repository" "courses" {
  name = "courses"
}