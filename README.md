# eks-secure-gitops-deploy

Welcome to this EKS secure GitOps-based deployment workflow on Amazon EKS using [ArgoCD](https://argo-cd.readthedocs.io/).

It includes a static website served from a lightweight Python container, with infrastructure provisioned using Terraform. The aim is to demonstrate secure, reproducible application delivery through Git-based automation and containerisation.

---

## Key Features

- GitOps deployment model via ArgoCD
- Infrastructure as code with Terraform
- Python-based static website in Docker
- Clean multi-stage Docker build
- Lightweight and secure by default

---

## ⚙️ Prerequisites

Make sure the following tools are installed and configured:

- [Docker](https://www.docker.com/)
- [Python 3](https://www.python.org/)
- [Terraform](https://developer.hashicorp.com/terraform)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [ArgoCD CLI (optional)](https://argo-cd.readthedocs.io/en/stable/cli_installation/)

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/CoderCo-Learning/eks-secure-gitops-deploy.git
cd eks-secure-gitops-deploy
```

---

## 2. Provision EKS Infrastructure

```
cd infrastructure
terraform init
terraform apply
```


### This will provision:

   - Amazon EKS cluster
   - IAM roles, networking, and security groups
   - ArgoCD namespace and initial resources (if defined in modules)

## 3. Build and test the app locally (optional)

```cd ../app
docker build -t eks-static-site .
docker run -p 3000:3000 eks-static-site
```
Open http://localhost:3000 in your browser.

---

## Security & Best Practice

- EKS security groups and IAM roles are defined via Terraform  
- Docker image uses a minimal base (`python:3.11-alpine`)  
- `.dockerignore` and `.gitignore` included to reduce build context and exposure


