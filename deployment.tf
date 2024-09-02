resource "kubernetes_manifest" "deployment_fiap_soat_sst_api" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "name"      = "sst-api"
      "namespace" = "fiap-soat"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "sst-api"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "sst-api"
          }
        }
        "spec" = {
          "containers" = [
            {
              "envFrom" = [
                {
                  "secretRef" = {
                    "name" = "sst-api-secrets"
                  }
                },
                {
                  "configMapRef" = {
                    "name" = "sst-env"
                  }
                },
              ]
              "image" = "evilfeeh/self-service-totem:v2.1.6"
              "livenessProbe" = {
                "failureThreshold" = 1
                "httpGet" = {
                  "path" = "/api/docs"
                  "port" = 3000
                }
                "periodSeconds"    = 5
                "successThreshold" = 1
                "timeoutSeconds"   = 1
              }
              "name" = "sst-api"
              "ports" = [
                {
                  "containerPort" = 3000
                },
              ]
              "readinessProbe" = {
                "failureThreshold" = 1
                "httpGet" = {
                  "path" = "/api/docs"
                  "port" = 3000
                }
                "periodSeconds" = 3
              }
              "resources" = {
                "limits" = {
                  "cpu"    = "2000m"
                  "memory" = "2Gi"
                }
                "requests" = {
                  "cpu"    = "300m"
                  "memory" = "128Mi"
                }
              }
              "startupProbe" = {
                "failureThreshold" = 30
                "httpGet" = {
                  "path" = "/api/docs"
                  "port" = 3000
                }
                "initialDelaySeconds" = 30
                "periodSeconds"       = 3
              }
            },
          ]
          "initContainers" = [
            {
              "command" = [
                "npm",
                "run",
                "migration:up",
              ]
              "envFrom" = [
                {
                  "secretRef" = {
                    "name" = "sst-api-secrets"
                  }
                },
                {
                  "configMapRef" = {
                    "name" = "sst-env"
                  }
                },
              ]
              "image" = "evilfeeh/self-service-totem:v2.1.6"
              "name"  = "migrate"
            },
          ]
        }
      }
    }
  }
}
