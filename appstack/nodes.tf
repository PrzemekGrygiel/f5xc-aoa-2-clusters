resource "terraform_data" "master" {
  count      = var.master_nodes_count
  depends_on = [ local_file.kubectl_manifest_master ]
  input      = {
    manifest   = "manifest/${var.f5xc_cluster_name}_m${count.index}.yaml"
    kubeconfig = var.f5xc_kubeconfig
    name       = "${var.f5xc_cluster_name}-m${count.index}"
  }

  provisioner "local-exec" {
    command     = "kubectl apply -f ${self.input.manifest} --kubeconfig ${self.input.kubeconfig} && kubectl wait --for=condition=ready pod -l vm.kubevirt.io/name=${self.input.name}"
  }
  provisioner "local-exec" {
    when        = destroy
    on_failure  = continue
    command     = "kubectl delete -f ${self.input.manifest} --kubeconfig ${self.input.kubeconfig}"
  }
}

resource "terraform_data" "worker" {
  count      = var.worker_nodes_count
  depends_on = [ local_file.kubectl_manifest_worker ]
  input      = {
    manifest   = "manifest/${var.f5xc_cluster_name}_w${count.index}.yaml"
    kubeconfig = var.f5xc_kubeconfig
    name       = "${var.f5xc_cluster_name}-w${count.index}"
  }

  provisioner "local-exec" {
    command     = "kubectl apply -f ${self.input.manifest} --kubeconfig ${self.input.kubeconfig} && kubectl wait --for=condition=ready pod -l vm.kubevirt.io/name=${self.input.name}"
  }
  provisioner "local-exec" {
    when        = destroy
    on_failure  = continue
    command     = "kubectl delete -f ${self.input.manifest} --kubeconfig ${self.input.kubeconfig}"
  }
}

