resource "oci_core_vcn" "test_vcn" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_ocid
  display_name   = var.name
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.test_vcn.id
  enabled        = "true"
  display_name   = "${var.name}-igw"
}


resource "oci_core_subnet" "test_subnet" {
  cidr_block     = var.subnet_cidr_block
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.test_vcn.id
}

resource "oci_core_route_table" "test_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.test_vcn.id
  display_name   = "${var.name}-rt"

  route_rules {
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_route_table_attachment" "test_route_table_attachment" {
  subnet_id      = oci_core_subnet.test_subnet.id
  route_table_id = oci_core_route_table.test_route_table.id
}
