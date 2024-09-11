resource "kubernetes_secret" "fiap_soat_sst_api_secrets" {
  metadata {
    name      = "sst-api-secrets"
    namespace = kubernetes_namespace.fiap_soat.metadata[0].name
  }

  data = {
    DB_DATABASE = "c2VsZi1zZXJ2aWNl"
    DB_HOST     = "c3N0LWRiLXN2Yw=="
    DB_PASSWORD = "bWNkb25hbGRzIzEyMzQ="
    DB_PORT     = "3306"
    DB_TYPE     = "bXlzcWw="
    DB_USERNAME = "bWNkb25hbGRz"
    PORT        = "3000"
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace.fiap_soat]
}
