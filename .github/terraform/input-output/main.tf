variable "required" {
  type = string
}

variable "optional" {
  type    = string
  default = null

  validation {
    condition = var.optional == null || var.optional == "bar"
    error_message = "`optional` must only be `null` or `\"bar\"`."
  }
}

output "required" {
  value = var.required
}

output "optional" {
  value = var.optional
}
