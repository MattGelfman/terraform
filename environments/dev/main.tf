module "network" {
  source     = "../../../modules/network"
  project_id = var.project_id
  region     = var.region
}

module "gke_autopilot" {
  source     = "../../../modules/gke_autopilot"
  project_id = var.project_id
  region     = var.region
  network    = module.network.network_name
  subnetwork = module.network.subnet_name
}
