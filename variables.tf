variable "hcloud_token" {
  type        = string
  description = "Authorization token for Hetzner Cloud"
  sensitive   = true
}

variable "server_name" {
  type        = string
  description = "Hetzner Cloud server name"
}

variable "server_type" {
  type        = string
  description = "Hetzner Cloud server type"
}

variable "server_image" {
  type        = string
  description = "Hetzner Cloud server image"
}

variable "server_location" {
  type        = string
  description = "Hetzner Cloud server location"
}

variable "k3s_version" {
  type        = string
  description = "Version of k3s to use"
  default     = "v1.36.2+k3s1"
}

variable "firewall_name" {
  type        = string
  description = "Hetzner Cloud firewall name"
}

variable "ssh_key_name" {
  type        = string
  description = "Hetzner Cloud SSH key name"
}

variable "allowed_ips" {
  type        = list(string)
  description = "List of allowed IPs"
}