resource "kubernetes_deployment" "fiap_soat_sst_api" {

  depends_on = [kubernetes_namespace.namespace_fiap_soat]

  metadata {
    name      = "sst-api"
    namespace = "fiap-soat"
    labels = {
      app = "sst-api"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "sst-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "sst-api"
        }
      }

      spec {
        container {
          name  = "sst-api"
          image = "evilfeeh/self-service-totem:v2.1.7"

          env_from {
            secret_ref {
              name = "sst-api-secrets"
            }
          }

          env_from {
            config_map_ref {
              name = "sst-env"
            }
          }

          port {
            container_port = 3000
          }

          resources {
            limits = {
              cpu    = "2"
              memory = "2Gi"
            }

            requests = {
              cpu    = "300m"
              memory = "128Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/api/docs"
              port = 3000
            }

            period_seconds    = 5
            success_threshold = 1
            failure_threshold = 1
            timeout_seconds   = 1
          }

          readiness_probe {
            http_get {
              path = "/api/docs"
              port = 3000
            }

            period_seconds    = 3
            success_threshold = 1
            failure_threshold = 1
            timeout_seconds   = 1
          }

          startup_probe {
            http_get {
              path = "/api/docs"
              port = 3000
            }

            period_seconds        = 3
            failure_threshold     = 30
            initial_delay_seconds = 30
          }
        }

        init_container {
          name  = "migrate"
          image = "evilfeeh/self-service-totem:v2.1.6"

          command = ["npm", "run", "migration:up"]

          env_from {
            secret_ref {
              name = "sst-api-secrets"
            }
          }

          env_from {
            config_map_ref {
              name = "sst-env"
            }
          }
        }
      }
    }
  }
}
