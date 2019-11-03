variable "ansible_dir" {
    default = "/home/ec2-user/terraform"
}
#Variable Location(zone)
variable "std_zone" {
    default = "us-east-2"
}
#variable credential path ( read only )
variable "my_credentials" {
  default = "/home/ec2-user/.aws/creds"
}
#log-in to the provider and select zone
provider "aws" {
 region = "${var.std_zone}"
 shared_credentials_file = "${var.my_credentials}"
 profile = "default"
}
#resource specs
resource "aws_instance" "web" {
# Count of VMs in aws  -  count                        = 4
#   ami - ID of machine (on creation pages)
    ami                          = "ami-00c03f7f7f2ec15c3"
#   availability_zone            = "us-east-2a"
    instance_type                = "t2.micro"
    key_name                     = "newOhio"
    private_ip                   = "172.31.21.188"
    subnet_id                    = "subnet-be6433c4"
    vpc_security_group_ids       = [aws_security_group.jenkinssg.id]
    tags                         = {
          Name = "Web_server"
        }

    provisioner "local-exec" {
      command = <<EOT
      sleep 50;
      working_dir = "${var.ansible_dir}"
      ansible-playbook -i hosts.txt java_tom.yml
      sleep 50;
      ansible-playbook -i hosts.txt tomcat_playbook.yml
      
  EOT
  }

}

#resource specs Jenkins Node
resource "aws_instance" "Jenkins" {
# Count of VMs in aws  -  count                        = 4
#   ami - ID of machine (on creation pages)
    ami                          = "ami-00c03f7f7f2ec15c3"
#   availability_zone            = "us-east-2a"
    instance_type                = "t2.small"
    key_name                     = "newOhio"
    private_ip                   = "172.31.21.189"
    subnet_id                    = "subnet-be6433c4"
    vpc_security_group_ids       = [aws_security_group.jenkinssg.id]
    root_block_device {
    volume_size = 20
    volume_type = "gp2"
    delete_on_termination = true
  }
    tags                         = {
          Name = "Masters"
        }

    provisioner "local-exec" {
      command = <<EOT
      sleep 50;
      working_dir = "${var.ansible_dir}"
      ansible-playbook -i hosts.txt java.yml
      sleep 50;
      ansible-playbook -i hosts.txt maven.yml
      sleep 50;
      ansible-playbook -i hosts.txt Playbook-jenkins.yml
    EOT
  }

}
#security group code
resource "aws_security_group" "jenkinssg" {
    name        = "Jenkins security group"
    description = "Security group for my needs for using Jenkins"
    vpc_id                 = "vpc-b4a051df"
    ingress {
      from_port     = 21
      to_port       = 8080
      protocol      = "tcp"
      cidr_blocks   = ["0.0.0.0/0"]
    }

    egress {
      from_port     = 0
      to_port       = 0
      protocol      = "-1"
      cidr_blocks   = ["0.0.0.0/0"]
    }
}

