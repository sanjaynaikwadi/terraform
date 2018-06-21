# Create Security group for instances and allow all incoming ports


resource "aws_security_group" "automation_vpc_secgroup" {
  name = "automation_secgroup"
  description = "Security group for Automation team created by Terraform"
  vpc_id = "${aws_vpc.automation-vpc.id}"

# All Ports
  ingress {
    from_port = 0
    to_port = 60000
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Security group for Automation team"
  }
}

