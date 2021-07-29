resource "aws_ecs_cluster" "ecs_cluster" {
    name  = "diplom"
    capacity_providers = [aws_ecs_capacity_provider.my-capacity-provider.name]
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "task1"
  container_definitions = jsonencode(
      [
  {
    "essential": true,
    "memory": 128,
    "name": "api",
    "cpu": 0,
    "portMappings": [
        {
          "hostPort": 80,
          "protocol": "tcp",
          "containerPort": 5000
        }
      ],
    "image": local.image_api,
    "links": [
        "micr1",
        "micr2"
      ],
    "environment": []
  },
  {
    "essential": true,
    "memory": 128,
    "name": "micr1",
    "cpu": 0,
    "image": local.image_courses,
    "environment": []
  },
  {
    "essential": true,
    "memory": 128,
    "cpu": 0,
    "name": "micr2",
    "image": local.image_bcknd,
    "links": [
        "micr1"
      ],
    "environment": [
        {
          "name": "IP_DB",
          "value": data.aws_instance.db.private_ip
        }
      ]
  }
]

  )
}

resource "aws_ecs_service" "worker" {
  name            = "worker"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 2
  force_new_deployment = true
  load_balancer {
    target_group_arn = aws_lb_target_group.group.arn
    container_name   = "api"
    container_port   = 5000
  }
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.my-capacity-provider.name
    weight = 1
  }

}


resource "aws_ecs_capacity_provider" "my-capacity-provider" {
  name = "dimplom-ecs-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs-asg.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}