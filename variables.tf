variable "name" {
  description = "The name of the application"
  type        = string
  default     = "serviceauthcentral"

  validation {
    condition     = can(regex("^[a-z](?:[-a-z0-9]{1,21}[a-z0-9])$", var.name))
    error_message = "The name must start with a lowercase letter and can contain lowercase letters, numbers, and hyphens. It must be between 2 and 22 characters long."
  }
}

variable "project_id" {
  description = "The GCP project id"
  type        = string
  validation {
    condition   = can(regex("^[a-z]([-a-z0-9]{0,61}[a-z0-9])?$", var.project_id))
    error_message = "The project_id is a GCP project name which starts with a lowercase letter, is 1 to 63 characters long, contains only lowercase letters, digits, and hyphens, and does not end with a hyphen."
  }
}

variable "regions" {
  description = "List of regions where resources will be created"
  type        = list(string)
}

variable "region_db_names" {
  description = "Map of regions to their respective database names"
  type        = map(string)
}

variable "key_ring_name" {
  description = "The key ring name"
  type        = string
}

variable "sign_key_name" {
  description = "The sign key name"
  type        = string
}

variable "sac_issuer" {
  description = "The SAC_ISSUER envirionment variable specifying the issuer"
  type        = string
}

variable "sac_cors_origins" {
  description = "The SAC_CORS_ORIGINS envirionment variable specifying the allowed origins"
  type        = string
}

variable "sac_user_redirecturi" {
  description = "The SAC_USER_REDIRECTURI envirionment variable specifying the redirect uri"
  type        = string
}

variable "sac_user_provider_github_clientid" {
  description = "The SAC_USER_PROVIDER_GITHUB_CLIENTID envirionment variable specifying the GitHub client id"
  type        = string
}

variable "sac_user_provider_github_clientsecret" {
  description = "The SAC_USER_PROVIDER_GITHUB_CLIENTSECRET envirionment variable specifying the GitHub client secret"
  type        = string
  sensitive   = true
}

variable "artifact_registry_host" {
  description = "The name of the Artifact Registry repository"
  type        = string
  default     = "us-docker.pkg.dev"
}

variable "artifact_registry_name" {
  description = "The name of the Artifact Registry repository"
  type        = string
}

variable "artifact_registry_project_id" {
  description = "The project to use for Artifact Registry. Will default to the project_id if not set."
  type        = string
  default     = null
  validation {
    condition   = var.artifact_registry_project_id == null || can(regex("^[a-z]([-a-z0-9]{0,61}[a-z0-9])?$", var.artifact_registry_project_id))
    error_message = "The artifact_registry_project_id is a GCP project name which starts with a lowercase letter, is 1 to 63 characters long, contains only lowercase letters, digits, and hyphens, and does not end with a hyphen."
  }
}

variable "serviceauthcentral_token_tag" {
  description = "The tag for the serviceauthcentral token image to deploy"
  type        = string
  default     = "dev" # Default to the development version
}