resource "kubernetes_secret" "sst_api_secrets" {
  metadata {
    name      = "sst-api-secrets"
    namespace = kubernetes_namespace.fiap_soat.metadata[0].name
  }

  data = {
    DB_DATABASE = var.db_database
    DB_HOST     = var.db_host
    DB_PASSWORD = var.db_password
    DB_PORT     = 3306
    DB_TYPE     = var.db_type
    DB_USERNAME = var.db_username
    PORT        = 3000
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace.fiap_soat]
}
