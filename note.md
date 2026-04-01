terraform code store on git 

terraform.tfsate store on s3

: Terraform + remote state in S3 + CI/CD (GitHub Actions) for auto-apply

1.1. Store Terraform state in AWS S3
backend.tf

2.Store code in GitHub
Push your Terraform code to a repo on GitHub.

3. Automate Terraform with GitHub Actions

This is where the magic happens 🚀
When you push code → GitHub runs Terraform automatically.

.github/workflows/terraform.yml