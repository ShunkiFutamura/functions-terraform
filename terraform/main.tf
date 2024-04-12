locals {
  project = var.projects # Google Cloud Platform Project ID
}

data "google_service_account" "account" {
  account_id   = var.service_account_id
  project = local.project
}

data "archive_file" "function_archive" {
  type        = "zip"
  source_dir  = "../functions/src"
  output_path = "./tmp/function-source.zip"
}
resource "google_storage_bucket_object" "source_code" {
  count  = 1
  name   = var.gcs_file_name
  bucket = var.gcs_bucket
  source = data.archive_file.function_archive.output_path
}

# Cloud Functionの作成
resource "google_cloudfunctions2_function" "function" {
    depends_on = [
    google_storage_bucket_object.source_code,
  ]
  name        = var.functions_name
  location    = "asia-northeast1"
  description = var.functions_description
  project     = local.project

  build_config {
    runtime     = "python311"
    entry_point = "main" # Set the entry point
    source {
      storage_source {
        object  = var.gcs_file_name
        bucket = var.gcs_bucket
      }
    }
  }
  service_config {
    min_instance_count = 1
    available_memory   = "512Mi"
    timeout_seconds    = 3600
    service_account_email = data.google_service_account.account.email
  }
}

resource "google_cloud_scheduler_job" "invoke_cloud_function" {
  name        = var.scheduler_name
  description = var.scheduler_description
  schedule    = var.scheduler_duration
  time_zone = "Asia/Tokyo"
  project     = google_cloudfunctions2_function.function.project
  region      = google_cloudfunctions2_function.function.location

  http_target {
    uri         = google_cloudfunctions2_function.function.service_config[0].uri
    http_method = "GET"
    oidc_token {
      audience              = "${google_cloudfunctions2_function.function.service_config[0].uri}/"
      service_account_email = data.google_service_account.account.email
    }
  }
}