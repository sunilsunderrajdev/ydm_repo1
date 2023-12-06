output "private_key" {
  value       = tls_private_key.EC2_private_key.private_key_pem
  description = "Content of the generated private key"
  sensitive   = false
}