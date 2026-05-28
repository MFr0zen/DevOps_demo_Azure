resource "azuread_application_federated_identity_credential" "github" {
  application_id = azuread_application.github.id
  display_name   = "github-main"
  description    = "GitHub Actions OIDC"

  audiences = ["api://AzureADTokenExchange"]

  issuer = "https://token.actions.githubusercontent.com"

  subject = "repo:MFr0zen/DevOps_demo_Azure:ref:refs/heads/main"
}