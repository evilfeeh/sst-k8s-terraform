resource "kubernetes_manifest" "service_fiap_soat_sst_api" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "labels" = {
        "app" = "sst-api"
      }
      "name" = "sst-api"
      "namespace" = "fiap-soat"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "sst-api"
          "port" = 80
          "protocol" = "TCP"
          "targetPort" = 3000
        },
      ]
      "selector" = {
        "app" = "sst-api"
      }
      "type" = "LoadBalancer"
    }
  }
}
