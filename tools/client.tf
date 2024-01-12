resource "terraform_data" "client-slo" {
  depends_on = [ local_file.kubectl_manifest_client ]
  input      = {
    manifest   = "manifest/client.yaml"
    kubeconfig = var.f5xc_kubeconfig
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


resource "local_file" "kubectl_manifest_client" {
    content  = templatefile("${path.module}/templates/client.yaml", {
  })
  filename = "manifest/client.yaml"
}