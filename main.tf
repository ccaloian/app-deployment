terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

variable "host" {
  type = string
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

provider "kubernetes" {
  host = var.host

  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}

resource "kubernetes_deployment" "imrec" {
  metadata {
    name = "image-recognition"
    labels = {
      App = "ImageRecognitionApp"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "ImageRecognitionApp"
      }
    }
    template {
      metadata {
        labels = {
          App = "ImageRecognitionApp"
        }
      }
      spec {
        container {
          image = "ccaloian/image-recognition"
          name  = "imrec"

          image_pull_policy = "Always"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "1"
              memory = "1Gi"
            }
            requests = {
              cpu    = "1"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "imrec" {
  metadata {
    name = "image-recognition"
  }
  spec {
    selector = {
      App = kubernetes_deployment.imrec.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

