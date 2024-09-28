# SST Kubernetes and terraform
[![Terraform Apply](https://github.com/evilfeeh/sst-k8s-terraform/actions/workflows/apply.yml/badge.svg)](https://github.com/evilfeeh/sst-k8s-terraform/actions/workflows/apply.yml)
[![Terraform Plan](https://github.com/evilfeeh/sst-k8s-terraform/actions/workflows/pullrequest.yml/badge.svg)](https://github.com/evilfeeh/sst-k8s-terraform/actions/workflows/pullrequest.yml)

this repository contains all the infrastructure of the Self Service Totem API.

This project is part of the FIAP SOAT course. This repository support our application created in Typescript. Go to [Self Service Totem](https://github.com/evilfeeh/self-service-totem) for more details.

## How it works

This terraform files provide a kubernetes solution to ensure the ingfrastructure that the application SST needs.
We provided an updated environmet when a new pull request is merged. updating this at the cloud.

## How to use

### Download the repo:
``` bash
  git clone https://github.com/evilfeeh/sst-k8s-terraform
```

### Fill the envs:
check out the env.auto.tfvars.sample and fill it with your environments variables

### Run init:
``` bash
  terraform init
```

### Validate:
Validate the file to ensure is everything correct with the resources
``` bash
  terraform validate 
```

### Plan the Changes
Generate and review an execution plan to preview the changes Terraform will apply:

``` bash
terraform plan
```

### Apply the Changes
Once the plan is reviewed, apply the changes to your cloud infrastructure:

``` bash
terraform apply
```

### Submit Changes via Pull Request
To update the infrastructure:

1. Make your changes.
2. Create a pull request.
3. Once the pull request is merged, the pipeline will automatically apply the changes and update the infrastructure.

create a new pull request with your applications.

When validated and merge, the pipeline will run and update the changes automatically.


## Contact
Please, feel free to open issues or contact the developers of the team. We'll be happy to help.