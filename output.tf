
output "clusters" {
  value = {
    tiny = module.tiny
    small = module.small
    large = module.large
  }
  sensitive = true
}
