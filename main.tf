provider "google" {
  project = "dev-sec-ops-leon"  # Replace with your project ID
  region  = "us-central1"
}

resource "google_storage_bucket" "tf_state" {
  name     = "my-tf-simple-vm"
  location = "us-central1"
  versioning {
    enabled = true  # Enable versioning for state recovery
  }
}

resource "google_compute_network" "cicd_network" {
  name                    = "cicd-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "cicd_subnet" {
  name          = "cicd-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = "us-central1"
  network       = google_compute_network.cicd_network.id
}

# Provision a Compute Engine instance
resource "google_compute_instance" "cicd_vm" {
  name         = "cicd-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"  # RedHat Enterprise Linux 8
    }
  }
  
  network_interface {
    subnetwork = google_compute_subnetwork.cicd_subnet.id
    access_config {}  # Assigns an external IP
  }
}