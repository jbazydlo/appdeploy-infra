output "node-ip" {
  description = "IP of the cluster node"
  value       = hcloud_server.appdeploy-node1.ipv4_address
}
