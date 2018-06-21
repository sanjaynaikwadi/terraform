# Create VPC and launch all instance in the following VPC
resource "aws_vpc" "automation-vpc" {
#        cidr_block = "10.0.0.0/16"
         cidr_block = "${var.vpc_cidr}"
         enable_dns_hostnames = true
         enable_dns_support = true
         tags {
         Name = "automation.local"
  }
}

#Create DHCP SET
resource "aws_vpc_dhcp_options" "foo" {
    domain_name = "automation.local"
#    domain_name_servers = ["8.8.4.4", "8.8.8.8"]
#    ntp_servers = ["127.0.0.1"]
#    netbios_name_servers = ["127.0.0.1"]
#    netbios_node_type = 2

    tags {
        Name = "automation-local"
    }
}


# Route 53 Zone Association
resource "aws_route53_zone" "automation-zone" {
  name   = "automation.local"
  vpc_id = "${aws_vpc.automation-vpc.id}"
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id = "${aws_vpc.automation-vpc.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.foo.id}"
}



#Create Public subnets in different AZ

#data "aws_availability_zones" "available" {}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "1a-public" {
        vpc_id = "${aws_vpc.automation-vpc.id}"
#        cidr_block = "10.0.1.0/24"
        cidr_block = "${var.public_subnet_cidr}"
#        availability_zone = "ap-south-1a"
        availability_zone = "${data.aws_availability_zones.available.names[0]}"
        map_public_ip_on_launch = true
        tags {
        Name = "Public 1A"
    }

}

resource "aws_subnet" "1b-public" {
        vpc_id = "${aws_vpc.automation-vpc.id}"
#        cidr_block = "10.0.2.0/24"
        cidr_block = "${var.private_subnet_cidr}"
#        availability_zone = "ap-south-1b"
         availability_zone = "${data.aws_availability_zones.available.names[0]}"
        map_public_ip_on_launch = true
        tags {
        Name = "Public 1B"
    }

}

# Routing table for public subnets

resource "aws_route_table" "route-public" {
        vpc_id = "${aws_vpc.automation-vpc.id}"

        route {
                cidr_block = "0.0.0.0/0"
                gateway_id = "${aws_internet_gateway.automation-gateway.id}"
        }
}

resource "aws_route_table_association" "1a-public" {
        subnet_id = "${aws_subnet.1a-public.id}"
        route_table_id = "${aws_route_table.route-public.id}"
}

resource "aws_route_table_association" "1b-public" {
        subnet_id = "${aws_subnet.1b-public.id}"
        route_table_id = "${aws_route_table.route-public.id}"
}

