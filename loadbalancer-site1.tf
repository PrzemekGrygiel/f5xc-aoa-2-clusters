module "site_wait_for_online1" {
  source         = "./modules/f5xc/status/site"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_namespace = module.namespace.namespace.name
  f5xc_site_name = format("%s-ipv6-site1", var.project_prefix)
  f5xc_tenant    = var.f5xc_tenant
  is_sensitive   = false
}  


module "workload_site1" {
  depends_on   = [module.site_wait_for_online1]
  source                = "./ipv6"
  f5xc_kubeconfig       = format("./%s-ipv6-site1.kubeconfig", var.project_prefix)
}

resource "time_sleep" "wait_n_seconds" {
  depends_on      = [restapi_object.pool1]
  create_duration = "30s"
}

resource "restapi_object" "lb1" {
  depends_on   = [module.site_wait_for_online1, module.workload_site1, time_sleep.wait_n_seconds]
  id_attribute = "metadata/name"
    path         = "/config/namespaces/${module.namespace.namespace.name}/http_loadbalancers"
    data         = jsonencode ({
      "metadata": {
        "name": format("%s-ipv6-site1-vip", var.project_prefix),
        "namespace": module.namespace.namespace.name,
        "labels": {},
        "annotations": {},
        "description": "HTTP loadbalancer object sb-ipv6 test",
        "disable": false
      },
      "spec": {
       "domains": [
         format("1.%s",var.domain)
       ],
       "http": {
         "dns_volterra_managed": false,
         "port": 80
       },
       "downstream_tls_certificate_expiration_timestamps": [],
       "advertise_custom": {
         "advertise_where": [
           {
             "site": {
               "network": "SITE_NETWORK_OUTSIDE",
               "site": {
                 "tenant": var.f5xc_tenant,
                 "namespace": "system",
                 "name": format("%s-ipv6-site1", var.project_prefix)
               },
               "ip": "10.251.251.101",
               "ipv6": "2001:cafe::101"
             },
             "port": 80
           }
         ]
       },
      "default_route_pools": [
       {
        "pool": {
          "tenant": var.f5xc_tenant,
          "namespace": module.namespace.namespace.name,
          "name": format("%s-ipv6-site1-pool", var.project_prefix),
          "kind": "origin_pool"
        },
        "weight": 1,
        "priority": 1,
        "endpoint_subsets": {}
       }
      ],
       "origin_server_subset_rule_list": null,
       "routes": [],
       "cors_policy": null,
       "disable_waf": {},
       "add_location": false,
       "no_challenge": {},
       "more_option": null,
       "user_id_client_ip": {},
       "disable_rate_limit": {},
       "malicious_user_mitigation": null,
       "waf_exclusion_rules": [],
       "data_guard_rules": [],
       "blocked_clients": [],
       "trusted_clients": [],
       "api_protection_rules": null,
       "ddos_mitigation_rules": [],
       "no_service_policies": {},
       "round_robin": {},
       "disable_trust_client_ip_headers": {},
       "disable_ddos_detection": {},
       "disable_malicious_user_detection": {},
       "disable_api_discovery": {},
       "disable_api_definition": {},
       "csrf_policy": null,
       "graphql_rules": [],
       "protected_cookies": [],
       "host_name": "",
       "dns_info": [],
       "state": "VIRTUAL_HOST_READY",
       "auto_cert_info": {
         "auto_cert_state": "AutoCertNotApplicable",
         "auto_cert_expiry": null,
         "auto_cert_subject": "",
         "auto_cert_issuer": "",
         "dns_records": [],
         "state_start_time": null
       },
       "internet_vip_info": [],
       "jwt_validation": null
     },
     "status_set": [],
     "ui_properties": {
       "auto_cert_status": ""
     }
    }
    )
}



resource "restapi_object" "pool1" {
  depends_on   = [module.site_wait_for_online1, module.workload_site1]
  id_attribute = "metadata/name"
    path         = "/config/namespaces/${module.namespace.namespace.name}/origin_pools"
    data         = jsonencode ({
    "metadata": {
      "name": format("%s-ipv6-site1-pool", var.project_prefix),
      "namespace": module.namespace.namespace.name,
      "labels": {},
      "annotations": {},
      "disable": false
    },
    "spec": {
      "origin_servers": [
        {
          "k8s_service": {
            "service_name": "nginx-service-1.default",
            "site_locator": {
              "site": {
                "tenant": var.f5xc_tenant,
                "namespace": "system",
                "name": format("%s-ipv6-site1", var.project_prefix),
                "kind": "site"
              }
            },
            "vk8s_networks": {}
          },
          "labels": {}
        }
      ],
      "no_tls": {},
      "port": 80,
      "same_as_endpoint_port": {},
      "healthcheck": [],
      "loadbalancer_algorithm": "LB_OVERRIDE",
      "endpoint_selection": "LOCAL_PREFERRED"
    }  
  })
}