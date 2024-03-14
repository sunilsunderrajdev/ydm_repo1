module "external_sg" {
    source = "terraform-aws-modules/security-group/aws"

    name        = "${var.env_code}-external"
    vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = "0.0.0.0/0"
        description = "Https to ELB from the internet"
    }
  ]

  egress_with_cidr_blocks = [
    {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = "0.0.0.0/0"
        description = "All traffic from hosts behind LB to the internet"
    }
  ]
}

module "alb" {
    source  = "terraform-aws-modules/alb/aws"
    version = "8.7.0"

    name                = var.env_code
    load_balancer_type  = "application"
    vpc_id              = data.terraform_remote_state.level1.outputs.vpc_id
    internal            = false
    subnets             = data.terraform_remote_state.level1.outputs.public_subnet_id
    security_groups     = [module.external_sg.security_group_id]

    target_groups = [
        {
            name_prefix             = var.env_code
            backend_port            = 80
            backend_protocol        = "HTTP"
            deregistration_delay    = 10

            health_check = {
                enabled             = true
                path                = "/"
                port                = "traffic-port"
                healthy_threshold   = 5
                unhealthy_threshold = 2
                timeout             = 5
                interval            = 30
                matcher             = "200"
                protocol            = "HTTP"
            }
        }
    ]

    https_listeners = [
        {
            port                = 443
            protocol            = "HTTPS"
            certificate_arn     = aws_acm_certificate.main.arn
            target_group_index  = 0
        }
    ]
}

resource "aws_acm_certificate" "main" {
    domain_name         = "www.${aws_route53_zone.main.name}"
    validation_method   = "DNS"

    tags = {
        name = var.env_code
    }
}

resource "aws_route53_record" "domain_validation" {
    for_each = {
        for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
            name    = dvo.resource_record_name
            record  = dvo.resource_record_value
            type    = dvo.resource_record_type
        }
    }

    allow_overwrite = true
    name            = each.value.name
    records         = [each.value.record]
    ttl             = 60
    type            = each.value.type
    zone_id         = aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
    certificate_arn         = aws_acm_certificate.main.arn
    validation_record_fqdns = [for record in aws_route53_record.domain_validation : record.fqdn]
}

resource "aws_route53_zone" "main" {
    name = "techpod.io"

    tags = {
        Name = var.env_code
    }
}

resource "aws_route53_record" "www" {
    zone_id = aws_route53_zone.main.zone_id
    name    = "www.${aws_route53_zone.main.name}"
    type    = "CNAME"
    ttl     = "300"
    records = [module.alb.lb_dns_name]
}

output "name_servers" {
    value   = aws_route53_zone.main.name_servers
}
