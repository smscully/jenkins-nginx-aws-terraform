########################################
# Route53 Module Outputs
########################################
output "route53_data" {
  description = "Route53 Data"
  value = {
    for website_dns_record in aws_route53_record.website_dns_record : website_dns_record.name => {
      type    = website_dns_record.type
      zone_id = website_dns_record.zone_id
    }
  }
}
