resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = var.image_id
    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
    security_groups      = [aws_security_group.sg.id]
    user_data            = file("user_data.sh")
    instance_type        = var.instance_type
}

resource "aws_autoscaling_group" "ecs-asg" {
    name                      = "asg"
    vpc_zone_identifier       = data.aws_subnet_ids.subnets.ids
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name
    desired_capacity          = var.desired_instances
    min_size                  = var.min_instances
    max_size                  = var.max_instances
    health_check_grace_period = 180
    health_check_type         = "EC2"
}
