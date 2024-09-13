resource "kubernetes_config_map" "configmap_fiap_soat_sst_env" {

  depends_on = [kubernetes_namespace.namespace_fiap_soat]

  metadata {
    name      = "sst-env"
    namespace = "fiap-soat"
  }

  data = {
    PORT            = "3000"
    SWAGGER_URL     = "localhost"
    URL_DEPLOY      = "http://34.95.232.166"
    URL_PAYMENT_API = "https://southamerica-east1-self-service-totem-428818.cloudfunctions.net/payment-fake"
  }
}
