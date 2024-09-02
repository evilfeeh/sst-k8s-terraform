# Provider configuration
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_manifest" "namespace_fiap_soat" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Namespace"
    "metadata" = {
      "name" = "fiap-soat"
    }
  }
}
