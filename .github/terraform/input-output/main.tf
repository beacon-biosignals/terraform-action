variable "required" {
  type = string
}

variable "optional" {
  type    = string
  default = null

  validation {
    condition = var.optional == null || var.optional == "foo"
    error_message = "`optional` must only be `null` or `\"foo\"`."
  }
}

output "required" {
  value = var.required
}

output "optional" {
  value = var.optional
}
