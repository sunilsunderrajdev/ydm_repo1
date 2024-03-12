data "aws_route53_zone" "main" {
  name = "techpod.io"
}

module "elb" {
    source = "terraform-aws-modules/alb/aws"

    name                = var.env_code
    internal            = false
    load_balancer_type  = "application"
    vpc_id              = data.terraform_remote_state.level1.outputs.vpc_id
    security_groups     = [module.external_sg.security_group_id]
    subnets             = data.terraform_remote_state.level1.outputs.public_subnet_id

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

    listeners = [
        {
                port                = 443
                protocol            = "HTTPS"
                certificate_arn     = module.acm.acm_certificate_arn

                forward = {
                    target_group_key = "ex-instance"
                }
        }
    ]
}

module "acm" {
    source = "terraform-aws-modules/acm/aws"

    domain_name = "${var.domain}.${var.hosted_zone}"
    zone_id     = data.aws_route53_zone.main.zone_id

    validation_method = "DNS"
    wait_for_validation = false

    tags = {
        Name = "${var.domain}.${var.hosted_zone}"
    }
}

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

module "dns" {
    source = "terraform-aws-modules/route53/aws//modules/records"

    zone_id = data.aws_route53_zone.main.zone_id

    records = [
        {
            name    = var.domain
            type    = "CNAME"
            records = [module.elb.dns_name]
            ttl     = 3600
        }
    ]
}
