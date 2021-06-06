resource "oci_core_vcn" "test_vcn" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_ocid
  display_name   = var.name
}

resource "oci_core_subnet" "test_subnet" {
  cidr_block     = var.subnet_cidr_block
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.test_vcn.id
}
