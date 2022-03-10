terraform {
  required_providers {
    google-beta = {
      source = "hashicorp/google-beta"
      version = "4.11.0"
    }
  }
}
 
provider "google-beta" {
  project = "thri-petproject"
  region = "europe-west1"
}