resource "google_service_account" "thri-name" {
  project = var.project
  account_id = "thri-name"
  display_name = "thrinad"
}
/*
resource "google_service_account_iam_policy" "admin-account-iam" {
  service_account_id = google_service_account.sp-name.name
  policy_data        = data.google_iam_policy.admin.policy_data
} */

data "google_iam_policy" "admin" {
  binding {
   // role = "roles/iam.serviceAccountUser"
   role = "roles/artifactregistry.repoAdmin"
    members = ["serviceAccount:${google_service_account.thri-name.email}"]
  }
}

resource "google_artifact_registry_repository" "my-repo" {
  project = var.project
  provider = google-beta
  location = "europe-west1"
  repository_id = "my-repository"
  description = "example docker repository with cmek"
  format = "DOCKER"
  // kms_key_name = "kms-key"
}

resource "google_artifact_registry_repository_iam_member" "test-iam" {
  project = var.project
  provider = google-beta
  location = google_artifact_registry_repository.my-repo.location
  repository = google_artifact_registry_repository.my-repo.name
  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.thri-name.email}"
}