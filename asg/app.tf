resource "aws_launch_configuration" "demo_aws" {
  image_id = "ami-b2df2ca4"
  instance_type = "t2.micro"
  key_name = "dev"
  enable_monitoring = false
  security_groups = ["${var.security_groups}"]

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<EOF
#cloud-config
runcmd:
  - docker run -d -p 8080:80 tutum/hello-world
EOF
}

resource "aws_autoscaling_group" "demo_aws" {
  launch_configuration = "${aws_launch_configuration.demo_aws.name}"

  max_size = 4
  min_size = 2

  health_check_type = "ELB"
  health_check_grace_period = 300
  force_delete = false
  default_cooldown = 120

  load_balancers = ["${aws_elb.demo_aws.name}"]

  availability_zones = ["${var.availability_zones}"]

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "demo_aws"
  }
}

resource "aws_elb" "demo_aws" {
  security_groups = ["${var.security_groups}"]
  cross_zone_load_balancing = true
  availability_zones = ["${var.availability_zones}"]

  listener {
    instance_port = 8080
    instance_protocol = "HTTP"
    lb_port = 8080
    lb_protocol = "HTTP"
  }

  health_check {
    healthy_threshold = 2
    interval = 30
    target = "HTTP:8080/"
    timeout = 10
    unhealthy_threshold = 2
  }
}