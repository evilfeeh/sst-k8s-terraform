resource "kubernetes_manifest" "configmap_fiap_soat_sst_env" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "PORT" = "3000"
      "SWAGGER_URL" = "localhost"
      "URL_DEPLOY" = "http://34.95.232.166"
      "URL_PAYMENT_API" = "https://southamerica-east1-self-service-totem-428818.cloudfunctions.net/payment-fake"
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "name" = "sst-env"
      "namespace" = "fiap-soat"
    }
  }
}
