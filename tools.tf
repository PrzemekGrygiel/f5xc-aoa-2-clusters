module "site_wait_for_online_tool" {
  source         = "./modules/f5xc/status/site"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_namespace = module.namespace.namespace.name
  f5xc_site_name = format("%s-ipv6-site1", var.project_prefix)
  f5xc_tenant    = var.f5xc_tenant
  is_sensitive   = false
}  

module "client" {
  depends_on   = [module.site_wait_for_online_tool]
  source                = "./tools"
  f5xc_kubeconfig       = var.f5xc_kubeconfig
}

