[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![Work In Progress](https://img.shields.io/badge/Status-Work%20In%20Progress-yellow)](https://unitvectory-labs.github.io/uvy-labs-guide/bestpractices/status/#work-in-progress)

# serviceauthcentral-token-gcp-tofu

This OpenTofu module is used for deploying ServiceAuthCentral token API to GCP.

## Usage

The basic use of this module is as follows:

```hcl
module "serviceauthcentral_token_gcp" {
    source = "git::https://github.com/UnitVectorY-Labs/serviceauthcentral-token-gcp-tofu.git?ref=main"
    name = "serviceauthcentral"
    project_id = var.project_id
    artifact_registry_name = "ghcr"
    regions = ["us-east1"]
    region_db_names = {
        "us-east1" = "sac-us-east1"
    }
    key_ring_name = "mykeyring"
    sign_key_name = "mykey"
    sac_issuer = "https://api.example.com"
    sac_cors_origins = "https://portal.example.com"
    sac_user_redirecturi = "https://portal.example.com/callback"
    sac_user_provider_github_clientid = "GITHUB_CLIENT_ID_GOES_HERE"
    sac_user_provider_github_clientsecret = "GITHUB_CLIENT_SECRET_GOES_HERE"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_v2_service.serviceauthcentral-token](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_project_iam_member.firestore_viewer_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.firestore](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.run](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.cloud_run_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_registry_host"></a> [artifact\_registry\_host](#input\_artifact\_registry\_host) | The name of the Artifact Registry repository | `string` | `"us-docker.pkg.dev"` | no |
| <a name="input_artifact_registry_name"></a> [artifact\_registry\_name](#input\_artifact\_registry\_name) | The name of the Artifact Registry repository | `string` | n/a | yes |
| <a name="input_artifact_registry_project_id"></a> [artifact\_registry\_project\_id](#input\_artifact\_registry\_project\_id) | The project to use for Artifact Registry. Will default to the project\_id if not set. | `string` | `null` | no |
| <a name="input_key_ring_name"></a> [key\_ring\_name](#input\_key\_ring\_name) | The key ring name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the application | `string` | `"serviceauthcentral"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project id | `string` | n/a | yes |
| <a name="input_region_db_names"></a> [region\_db\_names](#input\_region\_db\_names) | Map of regions to their respective database names | `map(string)` | n/a | yes |
| <a name="input_regions"></a> [regions](#input\_regions) | List of regions where resources will be created | `list(string)` | n/a | yes |
| <a name="input_sac_cors_origins"></a> [sac\_cors\_origins](#input\_sac\_cors\_origins) | The SAC\_CORS\_ORIGINS envirionment variable specifying the allowed origins | `string` | n/a | yes |
| <a name="input_sac_issuer"></a> [sac\_issuer](#input\_sac\_issuer) | The SAC\_ISSUER envirionment variable specifying the issuer | `string` | n/a | yes |
| <a name="input_sac_user_provider_github_clientid"></a> [sac\_user\_provider\_github\_clientid](#input\_sac\_user\_provider\_github\_clientid) | The SAC\_USER\_PROVIDER\_GITHUB\_CLIENTID envirionment variable specifying the GitHub client id | `string` | n/a | yes |
| <a name="input_sac_user_provider_github_clientsecret"></a> [sac\_user\_provider\_github\_clientsecret](#input\_sac\_user\_provider\_github\_clientsecret) | The SAC\_USER\_PROVIDER\_GITHUB\_CLIENTSECRET envirionment variable specifying the GitHub client secret | `string` | n/a | yes |
| <a name="input_sac_user_redirecturi"></a> [sac\_user\_redirecturi](#input\_sac\_user\_redirecturi) | The SAC\_USER\_REDIRECTURI envirionment variable specifying the redirect uri | `string` | n/a | yes |
| <a name="input_serviceauthcentral_token_tag"></a> [serviceauthcentral\_token\_tag](#input\_serviceauthcentral\_token\_tag) | The tag for the serviceauthcentral token image to deploy | `string` | `"dev"` | no |
| <a name="input_sign_key_name"></a> [sign\_key\_name](#input\_sign\_key\_name) | The sign key name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_region_service_map"></a> [region\_service\_map](#output\_region\_service\_map) | n/a |
<!-- END_TF_DOCS -->