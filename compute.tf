data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "template_file" "setup" {
  template = file("${path.module}/scripts/setup.sh")
}

data "template_file" "init-master-node" {
  template = file("${path.module}/scripts/init-master-node.sh")
}

resource "oci_core_instance" "master-node" {
  count               = 1
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.name}-master-node"

  shape = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = 12
    ocpus         = 2
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.test_subnet.id
  }

  source_details {
    source_id   = var.instance_image_ocid_oracle79_arm
    source_type = "image"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(join("\n", tolist([
      "#!/usr/bin/env bash",
      "set -x",
      (data.template_file.setup.rendered),
      (data.template_file.init-master-node.rendered)],
    )))
  }
}

resource "oci_core_instance" "worker-node-1" {
  count               = 1
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.name}-worker-node-1"

  shape = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = 6
    ocpus         = 1
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.test_subnet.id
  }

  source_details {
    source_id   = var.instance_image_ocid_oracle79_arm
    source_type = "image"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(join("\n", tolist([
      "#!/usr/bin/env bash",
      "set -x",
      (data.template_file.setup.rendered)],
    )))
  }
}
