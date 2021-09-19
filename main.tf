terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}


provider "kubernetes" {
  host = "${var.host}:${var.host_port}"

  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}

module "deployment" {
    source = "./modules/deployment"
    app_name = var.app_name
    image_name = var.image_name
    container_port = var.container_port
    node_port = var.node_port
}
