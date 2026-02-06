terraform {
  backend "gcs" {
    bucket = "titan-security-tfstate"
    prefix = "dev"
  }
}
