# Route53 Module

# Generates an AWS ACM certificate and Route 53 domain verification and website DNS records.

# This program is licensed under the terms of the GNU General Public License v3.0.

########################################
# Local Variables
########################################
locals {

  # AWS ACM Certificate Domain Validation Options
  # Because nested for_each loops are not supported, the flatten function is used to create
  # a flat list of objects to reference the domain validation object attributes
  dvo_values = flatten([
    for cert_key, cert in aws_acm_certificate.domain_cert : [
      for dvo in cert.domain_validation_options : {
        cert_key              = cert_key
        domain_name           = dvo.domain_name
        resource_record_name  = dvo.resource_record_name
        resource_record_value = dvo.resource_record_value
        resource_record_type  = dvo.resource_record_type
      }
    ]
  ])
}

########################################
# Create ACM Certificate
########################################
resource "aws_acm_certificate" "domain_cert" {

  for_each = var.instance_data

  domain_name       = each.value.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

}

########################################
# Create Route 53 Records
########################################
resource "aws_route53_record" "domain_verification_record" {

  for_each = tomap({
    for dvo in local.dvo_values : "${dvo.cert_key}-${dvo.domain_name}" => dvo
  })

  zone_id         = var.zone_id
  type            = each.value.resource_record_type
  name            = each.value.resource_record_name
  records         = [each.value.resource_record_value]
  ttl             = 60
  allow_overwrite = true

}

resource "aws_route53_record" "website_dns_record" {

  for_each = var.instance_data

  zone_id = var.zone_id
  name    = each.value.domain_name
  type    = "A"
  ttl     = 300
  records = [each.value.public_ip]

}
