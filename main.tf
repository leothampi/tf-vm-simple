provider "google" {
  project = "dev-sec-ops-leon"  # Replace with your project ID
  region  = "us-central1"
}

resource "google_storage_bucket" "tf_state" {
  name     = "my-terraform-state-bucket"
  location = "US-CENTRAL1"
  versioning {
    enabled = true  # Enable versioning for state recovery
  }
}
terraform {
  backend "gcs" {
    bucket  = "my-terraform-state-bucket"
    prefix  = "terraform/state"  # Optional: organizes state files in a folder
  }
}
