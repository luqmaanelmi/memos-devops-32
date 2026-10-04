variable "domain_name" {
  description = "The domain name for the ACM certificate"
  type        = string
}

variable "root_domain" {
  description = "The root domain for the Route53 hosted zone"
  type        = string
}