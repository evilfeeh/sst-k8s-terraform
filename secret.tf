resource "kubernetes_manifest" "secret_fiap_soat_sst_api_secrets" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "DB_DATABASE" = "c2VsZi1zZXJ2aWNl"
      "DB_HOST"     = "c3N0LWRiLXN2Yw=="
      "DB_PASSWORD" = "bWNkb25hbGRzIzEyMzQ="
      "DB_PORT"     = "3306"
      "DB_TYPE"     = "bXlzcWw="
      "DB_USERNAME" = "bWNkb25hbGRz"
      "PORT"        = "3000"
    }
    "kind" = "Secret"
    "metadata" = {
      "name"      = "sst-api-secrets"
      "namespace" = "fiap-soat"
    }
  }
}
