variable "access_key" {
    description = "The AWS access key."
}

variable "secret_key" {
    description = "The AWS secret key."
}

variable "region" {
    description = "The AWS region."
#    default = "ap-south-1"
    default = "ap-southeast-1"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.2.0/24"
}
