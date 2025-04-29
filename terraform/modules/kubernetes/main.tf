resource "kubernetes_namespace" "app" {
  metadata {
    name = "app"
  }
}

resource "kubernetes_deployment" "simple_ts_app" {
  metadata {
    name      = "simple-ts"
    namespace = "app"
    labels = {
      app = "simple-ts"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "simple-ts"
      }
    }

    template {
      metadata {
        labels = {
          app = "simple-ts"
        }
      }

      spec {
        container {
          name  = "simple-time-service"
          image = "sheikhabubaker19/simple-time-service"
          image_pull_policy = "Always"

          port {
            container_port = 8080
          }

          env {
            name = "TZ"
            value = "UTC"
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.app
  ]
}

resource "kubernetes_service" "simple_ts_svc" {
  metadata {
    name      = "simple-ts"
    namespace = "app"
    labels = {
      app = "simple-ts"
    }
  }

  spec {
    selector = {
      app = "simple-ts"
    }

    port {
      port        = 8080
      protocol    = "TCP"
      target_port = 8080
    }

    type = "ClusterIP"
  }

  depends_on = [
    kubernetes_deployment.simple_ts_app
  ]
}

resource "kubernetes_ingress_v1" "simple_ts_ingress" {
  metadata {
    name      = "simple-ts-ingress"
    namespace = "app"
    annotations = {
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/subnets" = join(",", [
        var.subnet_ids[0],
        var.subnet_ids[2]
      ])
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.simple_ts_svc.metadata[0].name
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}
