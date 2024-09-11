resource "kubernetes_namespace" "fiap_soat" {
  metadata {
    name = "fiap-soat"
  }
}
