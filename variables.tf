variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for vkazistov.pp.ua"
  type        = string
}

variable "domain" {
  description = "Root domain"
  type        = string
  default     = "vkazistov.pp.ua"
}

variable "subdomain" {
  description = "AWS subdomain prefix"
  type        = string
  default     = "aws"
}

variable "ssh_public_key" {
  description = "SSH public key for EC2 access"
  type        = string
}

variable "my_ip" {
  description = "Your IP for SSH access, e.g. 1.2.3.4/32"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (Amazon Linux 2023 eu-north-1)"
  type        = string
  default     = "ami-08c1762b0f609d3b9"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}