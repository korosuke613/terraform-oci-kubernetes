#!/bin/bash

echo "# Setup"

echo "## settings"

echo "### disable firewalld"
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo yum -y install iptables-services
sudo systemctl start iptables
sudo systemctl enable iptables
sudo systemctl start iptables.service
sudo systemctl enable iptables.service
export iptables_ssh_line_number="$(sudo grep -n 'INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT' /etc/sysconfig/iptables | sed -e 's/:.*//g')"
sudo sed -i -e "$${iptables_ssh_line_number}i -A INPUT -m state --state NEW -p tcp -m tcp --dport 80 -j ACCEPT" /etc/sysconfig/iptables
sudo sed -i -e "$${iptables_ssh_line_number}i -A INPUT -m state --state NEW -p tcp -m tcp --dport 443 -j ACCEPT" /etc/sysconfig/iptables
sudo sed -i -e "$${iptables_ssh_line_number}i -A INPUT -m state --state NEW -p tcp -m tcp --dport 2379 -j ACCEPT" /etc/sysconfig/iptables
sudo sed -i -e "$${iptables_ssh_line_number}i -A INPUT -m state --state NEW -p tcp -m tcp --dport 2380 -j ACCEPT" /etc/sysconfig/iptables
sudo sed -i -e "$${iptables_ssh_line_number}i -A INPUT -m state --state NEW -p tcp -m tcp --dport 10250 -j ACCEPT" /etc/sysconfig/iptables
sudo sed -i -e "$${iptables_ssh_line_number}i -A INPUT -m state --state NEW -p tcp -m tcp --dport 10251 -j ACCEPT" /etc/sysconfig/iptables
sudo sed -i -e "$${iptables_ssh_line_number}i -A INPUT -m state --state NEW -p tcp -m tcp --dport 10252 -j ACCEPT" /etc/sysconfig/iptables
sudo sed -i -e "$${iptables_ssh_line_number}i -A INPUT -m state --state NEW -p tcp -m tcp --dport 6443 -j ACCEPT" /etc/sysconfig/iptables
sudo systemctl restart iptables.service

echo "### disable swap"
sudo swapoff -a
sudo sed -i 's/^\/.swapfile/#\/.swapfile/' /etc/fstab

echo "### setting containerd"
sudo tee /etc/modules-load.d/containerd.conf <<EOF >/dev/null
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

echo "### setting k8s"
sudo tee /etc/sysctl.d/99-kubernetes-cri.conf <<EOF >/dev/null
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

echo "### apply"
sudo sysctl --system

echo "## installs"
echo "### install containerd"
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum update -y && sudo yum install -y containerd.io
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo systemctl restart containerd

echo "### install kubernetes kubelet kubeadm"
sudo tee /etc/yum.repos.d/kubernetes.repo <<EOF >/dev/null
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-aarch64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
