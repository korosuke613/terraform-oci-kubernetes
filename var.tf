variable "tenancy_ocid" {
  default = ""
}

variable "compartment_ocid" {
  default = ""
}

variable "name" {
  default = "k8s-cluster-arm"
}

variable "vcn_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.0.0.0/24"
}

variable "instance_image_ocid_ubuntu2004" {
  # https://docs.oracle.com/en-us/iaas/images/image/4d2aaffa-325f-4fe7-9e99-a5b1ee7f2cd1/
  default = "ocid1.image.oc1.ap-osaka-1.aaaaaaaa4opxgypfsfz7pu2hqka47tdynl3vgoy5ejckofqkygkxj2xnjijq"
}

variable "instance_image_ocid_oracle83_arm" {
  # https://docs.oracle.com/en-us/iaas/images/image/549ace3b-c303-474f-a838-6744affc1c28/
  default = "ocid1.image.oc1.ap-osaka-1.aaaaaaaaae7wa7br3cupoaiqtftj3ht2nmw2tvdryq5wryjqj6pibz22kqva"
}

variable "instance_image_ocid_oracle79_arm" {
  # https://docs.oracle.com/en-us/iaas/images/image/7e44cded-7bd3-410c-bb4c-f1a83cf8a786/
  default = "ocid1.image.oc1.ap-osaka-1.aaaaaaaah4raas5drc75cqhn6la5saqkhcz5rdccqh75eqram7ltemax4srq"
}

variable "ssh_public_key" {
  default = ""
}

variable "nsg_source_cidr" {
  description = "Allowed Ingress Traffic (CIDR Block)"
  default     = "0.0.0.0/0"
}

variable "nsg_ssh_port" {
  description = "SSH Port"
  default     = 22
}

variable "nsg_kubernetes_port" {
  description = "kubernetes Port"
  default     = 6443
}
