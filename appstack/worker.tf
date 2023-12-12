resource "terraform_data" "worker" {
  count      = var.worker_nodes_count
  depends_on = [ local_file.kubectl_manifest_worker ]
  input      = {
    manifest   = "manifest/${var.f5xc_cluster_name}_w${count.index}.yaml"
    kubeconfig = var.f5xc_kubeconfig
    name       = "${var.f5xc_cluster_name}-w${count.index}"
  }

  provisioner "local-exec" {
    command    = "kubectl apply -f ${self.input.manifest} --kubeconfig ${self.input.kubeconfig} && kubectl wait --for=condition=ready pod -l vm.kubevirt.io/name=${self.input.name} --kubeconfig ${self.input.kubeconfig}"
  }
  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = "kubectl delete -f ${self.input.manifest} --kubeconfig ${self.input.kubeconfig}"
  }
}

resource "local_file" "kubectl_manifest_worker" {
  count                      = var.worker_nodes_count
  content                    = templatefile("${path.module}/templates/rhel9-node-template.yaml", {
    cluster-name             = var.f5xc_cluster_name
    host-name                = format("w%d", count.index)
    latitude                 = var.f5xc_cluster_latitude
    longitude                = var.f5xc_cluster_longitude
    maurice-private-endpoint = module.maurice.endpoints.maurice_mtls
    maurice-endpoint         = module.maurice.endpoints.maurice
    site-registration-token  = volterra_token.site.id
    certifiedhardware        = "kvm-voltstack-combo"
    f5xc_rhel9_container     = var.f5xc_rhel9_container
  })
  filename = "manifest/${var.f5xc_cluster_name}_w${count.index}.yaml"
}
