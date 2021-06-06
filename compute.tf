data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

resource "oci_core_instance" "test_instance" {
  count               = 1
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard.E2.1.Micro"
  display_name        = var.name

  create_vnic_details {
    subnet_id = oci_core_subnet.test_subnet.id
  }

  source_details {
    source_id = var.instance_image_ocid_ubuntu2004
    source_type = "image"
  }
}
