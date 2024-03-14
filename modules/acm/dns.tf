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
    records = [aws_lb.main.dns_name]
}

output "name_servers" {
    value   = aws_route53_zone.main.name_servers
}
