
output "clusters" {
  value = {
    site1 = module.site1
    site2 = module.site2
  }
  sensitive = true
}
