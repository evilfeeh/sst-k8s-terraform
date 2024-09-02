# SST Kubernetes and terraform
this repository contains all the infrastructure of the Self Service Totem API.

This project is part of the FIAP SOAT course. This repository support our application created in Typescript. Go to [Self Service Totem](https://github.com/evilfeeh/self-service-totem) for more details.

## How it works

This terraform files provide a kubernetes solution to ensure the ingfrastructure that the application SST needs.
We provided an updated environmet when a new pull request is merged. updating this at the cloud.

## How to use

Download the repo
``` bash
  git clone https://github.com/evilfeeh/sst-k8s-terraform
```
Apply your changes to your local branch

check it the format
``` bash
  terraform fmt --check
```

Validate
``` bash
  terraform validate 
```

create a new pull request with your applications.

when validated and merge, the pipeline will run and update the changes automatically.


## Contact
Please, feel free to open issues or contact the developers of the team. We'll be happy to help.