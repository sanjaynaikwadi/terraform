# How to create GKE cluster and node pool with terraform

### Pre-requiste
 - Google SDK installed 
 - Create Project in Gcloud
 - Enable Kubernetes API for that project

# Part 1 - Getting user/service account on gcp for terraform to work
 
### Get Project List
```bash
gcloud projects list

PROJECT_ID                NAME             PROJECT_NUMBER
kthw-230018               kthw             217835502745
```

### Get exisiting service account list
```bash
gcloud iam service-accounts list
```

### Get ID from project list and create a service account and then create service account key
```bash
gcloud iam service-accounts create terraform --display-name "terraform"

gcloud iam service-accounts keys create terraform-account-key.json --iam-account terraform@kthw-230018.iam.gserviceaccount.com

gcloud iam service-accounts keys list  --iam-account terraform@kthw-230018.iam.gserviceaccount.com
```

### Attach Editor role to your service account
```bash
gcloud projects add-iam-policy-binding kthw-230018 \
  --member serviceAccount:terraform@kthw-230018.iam.gserviceaccount.com \
  --role roles/editor
```

# Part - 2 - Let's write terraform files for creating the cluster

 - variables.tf 
 - google.tf 

`variable.tf` - Define Region/Zone/Project/Machine-type
```bash
variable "region" {
    description = "The GCloud default region to use."
    default = "us-west1"
}

variable "zone" {
    description = "The GCloud default zone to use."
    default = "us-west1-c"
}

variable "project" {
    description = "The GCloud default project to use."
    default = "kthw-230018"
}

variable "pool_name" {
    description = "The GCloud default pool name to use."
    default = "primary-pool"
}

variable "machine_type" {
    description = "The GCloud default machine type to use."
    default = "n1-standard-1"
}

```

`google.tf` - Define provider, credentials (key which we created previously), cluster name / node pool name & count.

```tf
provider "google" {
  credentials = "${file("terraform-account-key.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

resource "google_container_cluster" "core" {
  name                     = "core-cluster-1"
  zone                     = "${var.zone}"
  remove_default_node_pool = true

  node_pool {
    name = "default-pool"
  }
}

resource "google_container_node_pool" "pool-1" {
  name       = "test-pool"
  cluster    = "${google_container_cluster.core.name}"
  zone       = "${var.zone}"
  node_count = "1"

  node_config {
    machine_type = "${var.machine_type}"
  }
}

```

 - Lets run the terraform 

```bash
terraform init
terraform plan
terraform apply 
```

 - Once your cluster is up you can get the credentials and set you kubectl to poin that cluster

```bash
gcloud container clusters get-credentials core-cluster-1
```

Hola !!! You cluster is up and running go ahead and play around it. 
