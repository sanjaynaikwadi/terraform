# RDS DB Subnet Group

resource "aws_db_subnet_group" "automation-db-subnet-group" {
  name       = "automation-db-subnet-group"
  subnet_ids = ["${aws_subnet.1a-public.id}","${aws_subnet.1b-public.id}"]

  tags {
    Name = "automation-db-subnet-group"
  }
}

# RDS Parameter Group
 resource "aws_rds_cluster_parameter_group" "automation-cl-para-group" {
  name        = "automation-cl-para-group"
  family      = "aurora5.6"
  description = "Automation RDS cluster parameter group"

#  parameter {
#    name  = "character_set_server"
#    value = "utf8"
#  }

#  parameter {
#    name  = "character_set_client"
#    value = "utf8"
#  }


}

resource "aws_db_parameter_group" "automation-db-para-group" {
  name   = "automation-db-para-group"
  family = "aurora5.6"
  description = "Automation RDS DB parameter group"

#  parameter {
#    name  = "character_set_server"
#    value = "utf8"
#  }

#  parameter {
#    name  = "character_set_client"
#    value = "utf8"
#  }

  parameter {
    name  = "max_connect_errors"
    value = "999999"
  }

}


# Launch RDS - Aurora Cluster

resource "aws_rds_cluster_instance" "kp-aurora" {
  count              = 2
  identifier         = "kp-aurora-${count.index}"
  cluster_identifier = "${aws_rds_cluster.automation.id}"
  instance_class     = "db.t2.small"
  publicly_accessible   = "true"
  db_parameter_group_name = "${aws_db_parameter_group.automation-db-para-group.id}"
}

resource "aws_rds_cluster" "automation" {
  cluster_identifier = "kp"
  vpc_security_group_ids = [ "${aws_security_group.automation_vpc_secgroup.id}" ]
  db_subnet_group_name = "${aws_db_subnet_group.automation-db-subnet-group.id}"
  database_name      = "mydb"
  master_username    = "admin"
  master_password    = "info1234567890"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.automation-cl-para-group.id}"
#  db_cluster_parameter_group_name = "${aws_db_parameter_group.automation-para-group.id}"
  skip_final_snapshot = "true"
}

output "cluster_address" {
    value = "${aws_rds_cluster.automation.address}"
}

