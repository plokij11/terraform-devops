# ─── SSH Key Pair ────────────────────────────────────────────
resource "aws_key_pair" "main" {
  key_name   = "terraform-key"
  public_key = var.ssh_public_key
}

# ─── Security Groups ─────────────────────────────────────────

resource "aws_security_group" "web_server" {
  name        = "web_server_sg"
  description = "Web server: HTTP/HTTPS from anywhere, SSH from my IP"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_server_sg"
  }
}

resource "aws_security_group" "app" {
  name        = "app_sg"
  description = "App server: port 8080 from web_server only, SSH from my IP"

  ingress {
    description     = "App port from web_server only"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server.id]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app_sg"
  }
}

# ─── EC2 Instances ───────────────────────────────────────────

resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.web_server.id]

  tags = {
    Name = "web_server"
  }
}

resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.app.id]

  tags = {
    Name = "app"
  }
}

# ─── Route53 Hosted Zone ─────────────────────────────────────
# Імпортується з існуючої зони: terraform import aws_route53_zone.aws_subdomain <ZONE_ID>

resource "aws_route53_zone" "aws_subdomain" {
  name = "${var.subdomain}.${var.domain}"
}

# ─── DNS A-записи в Route53 ──────────────────────────────────

resource "aws_route53_record" "web_server" {
  zone_id = aws_route53_zone.aws_subdomain.zone_id
  name    = "web-server.${var.subdomain}.${var.domain}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.web_server.public_ip]
}

resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.aws_subdomain.zone_id
  name    = "app.${var.subdomain}.${var.domain}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.app.public_ip]
}

# ─── Cloudflare NS делегування ───────────────────────────────
# for_each по списку NS серверів які AWS видав для зони

resource "cloudflare_record" "aws_ns" {
  for_each = toset(aws_route53_zone.aws_subdomain.name_servers)

  zone_id = var.cloudflare_zone_id
  name    = var.subdomain
  type    = "NS"
  content = each.value
  ttl     = 3600
  allow_overwrite = true
}