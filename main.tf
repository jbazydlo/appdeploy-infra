resource "hcloud_server" "appdeploy-node1" {
  name        = var.server_name
  image       = var.server_image
  server_type = var.server_type
  location    = var.server_location
  ssh_keys    = [hcloud_ssh_key.appdeploy-key.id]

  user_data = templatefile("manifests/cloud-init.yaml", {
    k3s_version = var.k3s_version
  })
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "hcloud_firewall" "appdeploy-firewall" {
  name = var.firewall_name
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = var.allowed_ips
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "6443"
    source_ips = var.allowed_ips
  }

}

resource "hcloud_ssh_key" "appdeploy-key" {
  name       = var.ssh_key_name
  public_key = file("~/.ssh/hetzner_key.pub")
}