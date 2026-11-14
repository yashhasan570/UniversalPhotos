resource "cloudflare_pages_domain" "Universal Photos_app_release_domain" {
  account_id   = var.cloudflare_account_id
  project_name = data.terraform_remote_state.cloudflare_account.outputs_app_archive_pages_project_name
  domain       = "docs."
}

resource "cloudflare_record" "Universal Photos_app_release_domain" {
  name = "docs."
  proxied = true
  ttl = 1
  type = "CNAME"
  content = data.terraform_remote_state.cloudflare_Universal Photos_app_docs.outputs_app_branch_pages_hostname
  zone_id = data.terraform_remote_state.cloudflare_account.outputs_app_zone_id
}
