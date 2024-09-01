resource "kubernetes_manifest" "horizontalpodautoscaler_fiap_soat_sst_api_hpa" {
  manifest = {
    "apiVersion" = "autoscaling/v1"
    "kind" = "HorizontalPodAutoscaler"
    "metadata" = {
      "name" = "sst-api-hpa"
      "namespace" = "fiap-soat"
    }
    "spec" = {
      "maxReplicas" = 10
      "minReplicas" = 1
      "scaleTargetRef" = {
        "apiVersion" = "apps/v1"
        "kind" = "Deployment"
        "name" = "sst-api"
      }
      "targetCPUUtilizationPercentage" = 70
    }
  }
}
