resource "kubernetes_namespace" "example" {
  metadata {
    name = var.namespace_name
    labels = {
      name = "soluble-label"
    }
    annotations = {
      name = "soluble-example"
    }
  }
}
resource "kubernetes_pod" "nginx" {
  metadata {
    name      = var.nginx_pod_name
    namespace = var.namespace_name
    labels = {
      app = "nginx"
    }
  }
  spec {
    container {
      name  = var.nginx_pod_name
      image = var.nginx_pod_image
    }
  }
}
resource "kubernetes_service" "nginx" {
  metadata {
    name      = var.nginx_pod_name
    namespace = var.namespace_name
  }
  spec {
    selector = {
      app = kubernetes_pod.nginx.metadata.0.labels.app
    }
    port {
      port = 8080
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

