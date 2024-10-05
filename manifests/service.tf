resource "kubernetes_service" "sst_api" {
  metadata {
    name      = "sst-api"
    namespace = kubernetes_namespace.fiap_soat.metadata[0].name

    labels = {
      app = "sst-api"
    }
  }

  spec {
    selector = {
      app = "sst-api"
    }

    type = "LoadBalancer"

    port {
      name        = "sst-api"
      port        = 80
      target_port = 3000
      protocol    = "TCP"
    }
  }

  depends_on = [kubernetes_deployment.sst_api, kubernetes_namespace.fiap_soat]
}
