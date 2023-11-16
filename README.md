# f5xc-aoa-cluster

Experimental deployment of 3-node Appstack site on infra Appstack with optional worker nodes.

Clone this repo: `git clone --recurse-submodules https://github.com/mwiget/f5xc-aoa-cluster`

Copy terraform.tfvars.example to terraform.tfvars, then update the file with credentials 
and number of desired master (1 or 3) and worker nodes (0..128).

## Prerequisites

- RHEL9 kubevirt docker container with RHEL9 CE qcow2 image

## Deployment

```
terraform init
terraform plan
terraform apply
```

Verify cluster with

```
$ kubectl get nodes --kubeconfig sb-scale-tiny.kubeconfig
NAME               STATUS   ROLES        AGE   VERSION
sb-scale-tiny-m0   Ready    ves-master   89m   v1.24.13-ves

$ kubectl get nodes --kubeconfig sb-scale-small.kubeconfig 
NAME                STATUS   ROLES        AGE   VERSION
sb-scale-small-m0   Ready    ves-master   69m   v1.24.13-ves
sb-scale-small-m1   Ready    ves-master   68m   v1.24.13-ves
sb-scale-small-m2   Ready    ves-master   69m   v1.24.13-ves
```
