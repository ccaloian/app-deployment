variable "app_name" {
    type = string
}

variable "image_name" {
    type = string
}

variable "container_port" {
    type = number
}

variable "node_port" {
    type = number
}

variable "host" {
  type = string
}

variable "host_port" {
    type = number
}

variable "client_certificate" {
  type = string
}

variable "client_key" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

