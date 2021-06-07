resource "oci_core_network_security_group" "test_nsg" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.test_vcn.id
  display_name   = var.name
}

# Allow Egress traffic to all networks
resource "oci_core_network_security_group_security_rule" "test_rule_egress" {
  network_security_group_id = oci_core_network_security_group.test_nsg.id

  direction   = "EGRESS"
  protocol    = "all"
  destination = "0.0.0.0/0"

}

# Allow SSH (TCP port 22) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "test_rule_ssh_ingress" {
  network_security_group_id = oci_core_network_security_group.test_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_source_cidr
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.nsg_ssh_port
      max = var.nsg_ssh_port
    }
  }
}

# Allow TCP port 6443 Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "test_rule_k8s_ingress" {
  network_security_group_id = oci_core_network_security_group.test_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.subnet_cidr_block
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.nsg_kubernetes_port
      max = var.nsg_kubernetes_port
    }
  }
}

