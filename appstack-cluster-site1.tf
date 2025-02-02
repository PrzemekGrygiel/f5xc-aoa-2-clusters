module "site1" {
  # count = 0
  source                = "./appstack"
  f5xc_cluster_name     = format("%s-ipv6-site1", var.project_prefix)
  master_nodes_count    = 1
  worker_nodes_count    = 0
  f5xc_tenant           = var.f5xc_tenant
  f5xc_api_url          = var.f5xc_api_url
  f5xc_namespace        = var.f5xc_namespace
  f5xc_api_token        = var.f5xc_api_token
  f5xc_api_ca_cert      = var.f5xc_api_ca_cert
  owner_tag             = var.owner
  f5xc_kubeconfig       = var.f5xc_kubeconfig
  f5xc_rhel9_container  = var.f5xc_rhel9_container
  admin_password        = var.admin_password
  f5xc_cluster_labels   = { "site-mesh" : format("%s-ipv6-site", var.project_prefix) }
  ssh_public_key        = file(var.ssh_public_key_file)
  master_node_cpus      = 4
  worker_node_cpus      = 4
  master_node_memory    = 16384
  worker_node_memory    = 16384
  slo_network           = "default-net"
  is_sensitive          = false
  f5xc_cluster_latitude = 47.18
  f5xc_cluster_longitude = 8.47
  kubevirt              = true
  # f5xc_tunnel_type      = "SITE_TO_SITE_TUNNEL_SSL"
  f5xc_http_proxy       = "http://10.200.2.30:3128"
}

