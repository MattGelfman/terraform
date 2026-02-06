# =====================================================================
# FIX TERRAFORM MODULE PATHS (VERBATIM, NO ESCAPING)
# =====================================================================

Write-Host "Rewriting main.tf with correct module paths..."

$main = @'
terraform {
  required_version = ">= 1.3.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source      = "../../modules/network"
  project_id  = var.project_id
  region      = var.region
  name_prefix = "titan"
  subnet_cidr = "10.20.0.0/16"
}

module "gateway_db" {
  source        = "../../modules/gateway_db"
  project_id    = var.project_id
  region        = var.region
  instance_name = "titan-gateway"
  database_name = "gateway"
}

module "audit_db" {
  source        = "../../modules/audit_db"
  project_id    = var.project_id
  region        = var.region
  instance_name = "titan-audit"
  database_name = "audit"
}

module "audit_bucket" {
  source             = "../../modules/audit_bucket"
  project_id         = var.project_id
  location           = "US"
  archive_after_days = 30
}

module "policies_bucket" {
  source     = "../../modules/policies_bucket"
  project_id = var.project_id
  location   = "US"
}

module "artifact_repo" {
  source        = "../../modules/artifact_repo"
  project_id    = var.project_id
  region        = var.region
  repository_id = "titan-dev"
  description   = "Titan Security container registry"
}

module "audit_topic" {
  source     = "../../modules/audit_topic"
  project_id = var.project_id
  topic_name = "titan-audit-events-dev"
}
'@

Set-Content -Path "main.tf" -Value $main -Encoding UTF8 -Force

Write-Host "main.tf updated successfully."

Write-Host "`nRunning terraform init -reconfigure..."
terraform init -reconfigure

Write-Host "`nRunning terraform plan..."
terraform plan

Write-Host "`nDone."
