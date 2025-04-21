########################################
# Main Module Outputs
########################################
output "networking_module" {
  value = module.networking
}

output "jenkins_module" {
  value = module.jenkins
}

output "route53_module" {
  value = module.route53
}
