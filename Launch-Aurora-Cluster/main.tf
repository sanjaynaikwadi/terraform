# Cloud Provider with access details
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# Access key to attach instance and use for remote login
resource "aws_key_pair" "sanjaynaikwadi" {
        key_name = "sanjaynaikwadi"
        public_key = "${file("PubKey/sanjaynaikwadi.pub")}"
}


