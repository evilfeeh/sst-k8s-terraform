resource "kubernetes_namespace" "namespace_fiap_soat" {
  metadata {
    name = "fiap-soat"
  }
}
