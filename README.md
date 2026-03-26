# Infrastructure — Terraform

## Структура репозиторію
- `providers.tf` — провайдери AWS, Cloudflare та S3 backend
- `variables.tf` — всі змінні конфігурації
- `main.tf` — основна інфраструктура
- `outputs.tf` — виводи після apply

## Інфраструктура
- **web_server** — EC2, відкритий HTTP (80) та HTTPS (443) для всього світу
- **app** — EC2, порт 8080 доступний лише з web_server
- SSH доступ до обох серверів з вашого IP
- Route53 Hosted Zone для `aws.vkazistov.pp.ua`
- NS делегування з Cloudflare на AWS

## Передумови
- Terraform >= 1.0 (`brew install terraform`)
- AWS CLI налаштований (`aws configure`)
- S3 bucket `vkazistov-terraform-state` створений в `eu-north-1`

## Використання

### Перший запуск
1. Скопіюй `terraform.tfvars.example` → `terraform.tfvars` і заповни значення
2. `terraform init`
3. `terraform import aws_route53_zone.aws_subdomain <ZONE_ID>` (якщо зона вже існує)
4. `terraform plan`
5. `terraform apply`

### Видалення інфраструктури
`terraform destroy`

## Важливо
- Файл `terraform.tfvars` містить секрети — **не комітити в git**
- State зберігається в S3: `vkazistov-terraform-state/infra/terraform.tfstate`