resource "kubernetes_service_account" "main" {
  metadata {
    name = "cloudsql-sa"
  }
  secret {
    name = "${kubernetes_secret.example.metadata.0.name}"
  }
}

resource "kubernetes_secret" "main" {
  metadata {
    name = "terraform-example"
  }
}