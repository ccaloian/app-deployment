resource "kubernetes_deployment" "deployment" {
  metadata {
    name = "${var.app_name}-deployment"
    labels = {
      app = "${var.app_name}"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "${var.app_name}"
      }
    }
    template {
      metadata {
        labels = {
          app = "${var.app_name}"
        }
      }
      spec {
        container {
          image = var.image_name
          name  = "app"

          image_pull_policy = "Always"

          port {
            container_port = var.container_port
          }

          resources {
            limits = {
              cpu    = "1"
              memory = "2Gi"
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

resource "kubernetes_service" "service" {
  metadata {
    name = "${var.app_name}-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.deployment.spec.0.template.0.metadata[0].labels.app
    }
    port {
      node_port   = var.node_port
      port        = var.container_port
      target_port = var.container_port
    }

    type = "NodePort"
  }
}


