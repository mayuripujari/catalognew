variable "PIPOD_DEPLOYMENT_ID" {
  type    = string
  default = "1"
  description = "Deployment ID"
}

variable "tags" {
  type = map
  default = null
  description = "Default tags"
}