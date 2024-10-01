resource "kubernetes_deployment" "sst_api" {

  depends_on = [kubernetes_namespace.fiap_soat, kubernetes_config_map.sst_env, kubernetes_secret.sst_api_secrets]

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
          image = "evilfeeh/self-service-totem:2.1.23"

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
              path = "/public/docs"
              port = 3000
            }

            period_seconds    = 5
            success_threshold = 1
            failure_threshold = 1
            timeout_seconds   = 1
          }

          readiness_probe {
            http_get {
              path = "/public/docs"
              port = 3000
            }

            period_seconds    = 3
            success_threshold = 1
            failure_threshold = 1
            timeout_seconds   = 1
          }

          startup_probe {
            http_get {
              path = "/public/docs"
              port = 3000
            }

            period_seconds        = 3
            failure_threshold     = 30
            initial_delay_seconds = 30
          }
        }

        init_container {
          name  = "migrate"
          image = "evilfeeh/self-service-totem:2.1.23"

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
