variable "name" {
  description = "The name of the application"
  type        = string
  default     = "serviceauthcentral"
}

variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "regions" {
  description = "List of regions where resources will be created"
  type        = list(string)
}

variable "region_db_names" {
  description = "Map of regions to their respective database names"
  type        = map(string)
}

variable "kms_existing_key" {
  description = "Boolean value indicating if an existing KMS key should be used"
  type        = bool
  default     = false
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
}