# Infrastructure — Terraform

## Repository Structure
- `providers.tf` — AWS, Cloudflare providers and S3 backend configuration
- `variables.tf` — all configuration variables
- `main.tf` — main infrastructure
- `outputs.tf` — outputs after apply

## Infrastructure
- **web_server** — EC2, HTTP (80) and HTTPS (443) open to the world
- **app** — EC2, port 8080 accessible only from web_server
- SSH access to both servers from your IP
- Route53 Hosted Zone for `aws.vkazistov.pp.ua`
- NS delegation from Cloudflare to AWS

## Prerequisites
- Terraform >= 1.0 (`brew install terraform`)
- AWS CLI configured (`aws configure`)
- S3 bucket `vkazistov-terraform-state` created in `eu-north-1`

## Usage

### First run
1. Create `terraform.tfvars` and fill in the variable values according to `variables.tf`
2. `terraform init`
3. `terraform import aws_route53_zone.aws_subdomain <ZONE_ID>` (if the zone already exists)
4. `terraform plan`
5. `terraform apply`

### Destroy infrastructure
`terraform destroy`

## Important
- `terraform.tfvars` contains secrets — **do not commit to git**
- State is stored in S3: `vkazistov-terraform-state/infra/terraform.tfstate`