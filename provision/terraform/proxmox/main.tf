terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}

variable "proxmox_api_url" {
  type = string
}

variable "ssh_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
}

resource "proxmox_vm_qemu" "kube-0-homelab-local" {
  name        = "kube-0.homelab.local"
  target_node = "asterix"
  clone       = "rocky-template-asterix.homelab.local"
  full_clone  = true
  agent       = 1
  os_type     = "cloud-init"
  cores       = 4
  sockets     = 1
  cpu         = "host"
  memory      = 12288
  scsihw      = "virtio-scsi-pci"

  disk {
    size    = "74G"
    type    = "scsi"
    storage = "data-nvme"
    slot    = "0"
    format  = "raw"
  }

  # disk {
  #   size    = "64G"
  #   type    = "scsi"
  #   storage = "data-nvme"
  #   slot    = "1"
  #   format  = "raw"
  # }

  # Setup the network interface and assign a vlan tag: 256
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  sshkeys = file(pathexpand(var.ssh_path))

  ipconfig0 = "ip=192.168.1.40/24,gw=192.168.1.1,ip6=dhcp"
  ciuser    = "admin"
}

resource "proxmox_vm_qemu" "kube-1-homelab-local" {
  name        = "kube-1.homelab.local"
  target_node = "asterix"
  clone       = "rocky-template-asterix.homelab.local"
  full_clone  = true
  agent       = 1
  os_type     = "cloud-init"
  cores       = 4
  sockets     = 1
  cpu         = "host"
  memory      = 8192
  scsihw      = "virtio-scsi-pci"

  disk {
    size    = "74G"
    type    = "scsi"
    storage = "data-nvme"
    slot    = "0"
    format  = "raw"
  }

  # disk {
  #   size    = "64G"
  #   type    = "scsi"
  #   storage = "data-nvme"
  #   slot    = "1"
  #   format  = "raw"
  # }

  # Setup the network interface and assign a vlan tag: 256
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  sshkeys = file(pathexpand(var.ssh_path))

  ipconfig0 = "ip=192.168.1.41/24,gw=192.168.1.1,ip6=dhcp"
  ciuser    = "admin"
}

resource "proxmox_vm_qemu" "kube-2-homelab-local" {
  name        = "kube-2.homelab.local"
  target_node = "thinkcentre"
  clone       = "rocky-template-thinkcentre.homelab.local"
  full_clone  = true
  agent       = 1
  os_type     = "cloud-init"
  cores       = 4
  sockets     = 1
  cpu         = "host"
  memory      = 12288
  scsihw      = "virtio-scsi-pci"

  disk {
    size    = "74G"
    type    = "scsi"
    storage = "local-lvm"
    slot    = "0"
    format  = "raw"
  }

  # disk {
  #   size    = "64G"
  #   type    = "scsi"
  #   storage = "local-lvm"
  #   slot    = "1"
  #   format  = "raw"
  # }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  sshkeys   = file(pathexpand(var.ssh_path))
  ipconfig0 = "ip=192.168.1.42/24,gw=192.168.1.1,ip6=dhcp"
  ciuser    = "admin"
}
