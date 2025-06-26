variable "project_name" {
  description = "This would be our project name"
  type = string
}

variable "region" {
  description = "This is the region to be used in the project"
}

variable "vpc_cidr" {
    description = "This is the VPC cidr range"
}

variable pub_sub_1a_cidr {
    description = "# Public subnet for the NAT Gateway"
}

variable pub_sub_2b_cidr {
    description = "# Public subnet for the NAT Gateway"
}

variable pri_sub_3a_cidr {
    description = "Private subnet for the Wev Server"
}

variable pri_sub_4b_cidr {
    description = "Private subnet for the Wev Server"
}

variable pri_sub_5a_cidr {
    description = "Private subnet for DB Server"
}
variable pri_sub_6b_cidr {
    description = "Private subnet for DB Server"
}

variable db_username {}
variable db_password {}

variable certificate_domain_name {}
variable additional_domain_name {}
