terraform {
  backend "s3" {
    bucket         = "eks-secure-gitops-tfstate"
    key            = "global/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }
}
