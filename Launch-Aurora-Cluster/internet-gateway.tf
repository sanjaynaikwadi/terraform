# Access to Internet add Internet gateway
resource "aws_internet_gateway" "automation-gateway" {
        vpc_id = "${aws_vpc.automation-vpc.id}"
        tags {
        Name = "Automation gateway"
    }
}


