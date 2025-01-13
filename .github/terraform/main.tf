# Based off of: https://developer.hashicorp.com/terraform/tutorials/docker-get-started/docker-build
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

variable "image" {
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

resource "docker_image" "web_server" {
  name         = var.image
  keep_locally = false
}

resource "docker_container" "web_server" {
  image = docker_image.web_server.image_id
  name  = "web-server"
  ports {
    internal = 80
    external = 8000
  }
}
