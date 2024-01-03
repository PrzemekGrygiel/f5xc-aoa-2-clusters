resource "terraform_data" "workload" {
  depends_on = [ local_file.kubectl_manifest_workload ]
  input      = {
    manifest   = "manifest/workload.yaml"
    kubeconfig = var.f5xc_kubeconfig
    name       = "nginx-site1"
  }

  provisioner "local-exec" {
    command    = "kubectl apply -f ${self.input.manifest} --kubeconfig ${self.input.kubeconfig} && kubectl wait --for=condition=ready pod -l app=nginx --kubeconfig ${self.input.kubeconfig}"
  }
  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = "kubectl delete -f ${self.input.manifest} --kubeconfig ${self.input.kubeconfig}"
  }
}


resource "local_file" "kubectl_manifest_workload" {
    content  = templatefile("${path.module}/templates/workload.yaml", {

  })
  filename = "manifest/workload.yaml"
}