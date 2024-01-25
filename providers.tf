provider "aws" {
  allowed_account_ids     = [var.account_id]
  access_key              = var.access_key
  secret_key              = var.secret_key
  region                  = var.region
  skip_metadata_api_check = true
  default_tags {
    tags = {
      GitHubRepo = "sagemaker-stop-all-apps-lambda"
      Workspace  = "sagemaker-stop-all-apps-lambda"
    }
  }
}