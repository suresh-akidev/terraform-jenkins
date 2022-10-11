terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.21"
    }    
  }

}

provider "aws" {
    region = "ap-south-1"
}

resource "aws_security_group" "terra-sg" {
    description = "terraform security group"
    name = "terraform-sg-01"
    vpc_id = "vpc-06f4255c5722106aa"
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        description = "port to http"
        from_port = 80
        protocol = "tcp"
        to_port = 80
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        description = "ssh connection"
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        description = "port to https"
        from_port = 443
        protocol = "tcp"
        to_port = 443
    }

    tags = {
    Environment = "DEV"
  }
}

resource "aws_sns_topic" "terra_SNS_topic" {
    name = "terra_SNS_topic"
     tags = {
    Environment = "DEV"
  }
}

resource "aws_cloudwatch_metric_alarm" "terra_CPU_alarm" {
    alarm_name = "terra_CPU_alarm"
    alarm_description = "alram description"
    actions_enabled = true
    alarm_actions = [
        aws_sns_topic.terra_SNS_topic.arn
    ]
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    statistic = "Average"
    dimensions = {
        InstanceId = aws_instance.terra_ec2.id
    }
    period = 300
    evaluation_periods = 1
    datapoints_to_alarm = 1
    threshold = 50
    comparison_operator = "GreaterThanThreshold"
    treat_missing_data = "missing"
}

resource "aws_instance" "terra_ec2" {
    ami = "ami-062df10d14676e201"
    instance_type = "t2.medium"
    key_name = "ec2_key_pair"
    availability_zone = "ap-south-1a"
    tenancy = "default"
    subnet_id = "subnet-00d2838782fa3ecee"
    vpc_security_group_ids = [
        "sg-085a51b739df34661"
    ]
    associate_public_ip_address = true
    root_block_device {
        volume_size = 20
        volume_type = "gp2"
        delete_on_termination = true
    }

    user_data = <<-EOF
        #!/bin/bash
        sudo apt update
        sudo apt install apache2 -y
        sudo systemctl enable apache2
        sudo systemctl start apache2
        EOF
 
    tags = {
    Name = "terra-ec2",
    Environment = "DEV"
  }
}

resource "aws_ebs_volume" "volume" {

availability_zone = aws_instance.terra_ec2.availability_zone
    size = 10

    tags = {

        Name = "terraformTesting"
    }    
}

resource "aws_volume_attachment" "ebsAttach" {

    device_name = "/dev/sdh"
    volume_id = aws_ebs_volume.volume.id
    instance_id = aws_instance.terra_ec2.id

}
