module "namespace" {     
  source                                = "./modules/f5xc/namespace"
  f5xc_namespace_name                   = var.f5xc_namespace_lb
} 