# Enable required APIs for Cloud Run and Firestore
resource "google_project_service" "run" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "firestore" {
  project            = var.project_id
  service            = "firestore.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "kms" {
  project            = var.project_id
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
}

# Check if the key ring already exists
data "google_kms_key_ring" "existing_key_ring" {
  count    = var.kms_existing_key ? 1 : 0
  project  = var.project_id
  name     = "serviceauthcentral-key-ring-${var.name}"
  location = "global"
}

# Create the KMS key ring only if it doesn't exist
resource "google_kms_key_ring" "sign_key_ring" {
  count    = var.kms_existing_key ? 0 : 1
  project  = var.project_id
  name     = "serviceauthcentral-key-ring-${var.name}"
  location = "global"
}

# Determine the correct key ring ID to use
locals {
  key_ring_id = var.kms_existing_key ? data.google_kms_key_ring.existing_key_ring[0].id: google_kms_key_ring.sign_key_ring[0].id
}

# Check if the crypto key already exists
data "google_kms_crypto_key" "existing_crypto_key" {
  count    = var.kms_existing_key ? 1 : 0
  name     = "serviceauthcentral-sign-key-${var.name}"
  key_ring = local.key_ring_id
}

# Create the crypto key only if it doesn't exist
resource "google_kms_crypto_key" "asymmetric_sign_key" {
  count                         = var.kms_existing_key ? 0 : 1
  name                          = "serviceauthcentral-sign-key-${var.name}"
  key_ring                      = local.key_ring_id
  purpose                       = "ASYMMETRIC_SIGN"
  destroy_scheduled_duration    = "86400s"
  skip_initial_version_creation = true

  version_template {
    protection_level = "SOFTWARE"
    algorithm        = "RSA_SIGN_PKCS1_2048_SHA256"
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Local variable for the crypto key
locals {
  async_key      = var.kms_existing_key ? data.google_kms_crypto_key.existing_crypto_key[0].id : google_kms_crypto_key.asymmetric_sign_key[0].id
  key_ring_parts = split("/", local.async_key)
  key_ring_name  = local.key_ring_parts[5]
  sign_key_name  = local.key_ring_parts[7]
}

# Service account for Cloud Run services
resource "google_service_account" "cloud_run_sa" {
  project      = var.project_id
  account_id   = "sac-token-cr-${var.name}"
  display_name = "serviceauthcentral Cloud Run (${var.name}) service account"
}

# IAM role to grant Firestore write permissions to Cloud Run service account
resource "google_project_iam_member" "firestore_viewer_role" {
  project = var.project_id
  role    = "roles/datastore.viewer"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

# Deploy Cloud Run services in specified regions
resource "google_cloud_run_v2_service" "serviceauthcentral-token" {
  for_each = toset(var.regions)
  project  = var.project_id
  location = each.value
  name     = "${var.name}-token-${each.value}"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  template {
    service_account = google_service_account.cloud_run_sa.email

    containers {
      image = "us-docker.pkg.dev/${var.project_id}/ghcr/unitvectory-labs/serviceauthcentral-token:dev"

      env {
        name  = "GOOGLE_CLOUD_PROJECT"
        value = var.project_id
      }
      env {
        name  = "SPRING_PROFILES_ACTIVE"
        value = "datamodel-firestore,sign-gcp,verify-auth0"
      }
      env {
        name  = "SAC_ISSUER"
        value = var.sac_issuer
      }
      env {
        name  = "SAC_CORS_ORIGINS"
        value = var.sac_cors_origins
      }
      env {
        name  = "SAC_USER_REDIRECTURI"
        value = var.sac_user_redirecturi
      }
      env {
        name  = "SAC_SIGN_GCP_KEY_RING"
        value = local.key_ring_name
      }
      env {
        name  = "SAC_SIGN_GCP_KEY_NAME"
        value = local.sign_key_name
      }
      env {
        name  = "SAC_USER_PROVIDER_GITHUB_CLIENTID"
        value = var.sac_user_provider_github_clientid
      }
      env {
        name  = "SAC_USER_PROVIDER_GITHUB_CLIENTSECRET"
        value = var.sac_user_provider_github_clientsecret
      }
    }
  }
}
