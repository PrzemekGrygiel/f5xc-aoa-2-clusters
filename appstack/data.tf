resource "local_file" "kubectl_manifest_master" {
  count   = var.master_nodes_count
    content  = templatefile("${path.module}/templates/rhel9-node-template.yaml", {
    cluster-name = var.f5xc_cluster_name
    host-name = format("m%d", count.index)
    latitude = var.f5xc_cluster_latitude
    longitude = var.f5xc_cluster_longitude
    maurice-private-endpoint = module.maurice.endpoints.maurice_mtls
    maurice-endpoint = module.maurice.endpoints.maurice
    site-registration-token = volterra_token.site.id
    certifiedhardware = "kvm-voltstack-combo"
  })
  filename = "manifest/${var.f5xc_cluster_name}_m${count.index}.yaml"
}

resource "local_file" "kubectl_manifest_worker" {
  count   = var.worker_nodes_count
  content  = templatefile("${path.module}/templates/rhel9-node-template.yaml", {
    cluster-name = var.f5xc_cluster_name
    host-name = format("w%d", count.index)
    latitude = var.f5xc_cluster_latitude
    longitude = var.f5xc_cluster_longitude
    maurice-private-endpoint = module.maurice.endpoints.maurice_mtls
    maurice-endpoint = module.maurice.endpoints.maurice
    site-registration-token = volterra_token.site.id
    certifiedhardware = "kvm-voltstack-combo"
  })
  filename = "manifest/${var.f5xc_cluster_name}_w${count.index}.yaml"
}

