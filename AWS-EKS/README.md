## Terraform EKS Workshop

- Clone the code and create a SSH directory, you will need to generate the key pair for connecting to the node instances.
- Once you generate the key file update `worker.tf` with correct pub file to connect the instance.
- In `terraform.tfvars` update your ACCESS & SECRET Keys.
- Currently I have used `ap-south-1` region, you can modify this in `variables.tf` & `terraform.tfvars`

Once you are ready then run the following commands
- terraform validate
- terraform plan
- terraform apply

Once you have your cluster up and running, update the kubeconfig. Cluster you can find from the output once returned by completeion of terraform apply.
- aws eks update-kubeconfig --region ap-south-1 --name terraform-px-sn-cluster
