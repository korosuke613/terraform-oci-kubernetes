variable "tenancy_ocid" {
  default = ""
}

variable "compartment_ocid" {
  default = ""
}

variable "name" {
  default = "terraform-test"
}

variable "vcn_cidr_block" {
  default = "192.168.100.0/24"
}

variable "subnet_cidr_block" {
  default = "192.168.100.0/27"
}

variable "instance_image_ocid_ubuntu2004" {
  # https://docs.oracle.com/en-us/iaas/images/image/4d2aaffa-325f-4fe7-9e99-a5b1ee7f2cd1/
  default = "ocid1.image.oc1.ap-osaka-1.aaaaaaaa4opxgypfsfz7pu2hqka47tdynl3vgoy5ejckofqkygkxj2xnjijq"
}
