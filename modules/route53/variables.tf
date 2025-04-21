########################################
# Route53 Module Variables
########################################
variable "zone_id" {
  description = "ID of the AWS Hosted Zone."
  type        = string
}

variable "instance_data" {
  type = map(map(string))
}
