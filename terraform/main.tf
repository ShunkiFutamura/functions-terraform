# サービスアカウントを作成
resource "google_service_account" "functions" {
  project      = var.project
  account_id   = "test-sa"
  display_name = "テスト運用SA"
}


# ソースコードをアーカイブ
data "archive_file" "function_archive" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = var.output_path
}

resource "google_storage_bucket_object" "source_code" {
  name   = "gcp_function/function-source.zip"
  bucket = var.bucket_name
  source = var.output_path
}

# Cloud Functionの作成
resource "google_cloudfunctions2_function" "main" {
  name        = var.functions_name
  location    = var.region
  description = var.function_description
  project     = var.project

  build_config {
    runtime     = var.function_runtime
    entry_point = "main" # Set the entry point
    source {
      storage_source {
        bucket = var.bucket_name
        object = google_storage_bucket_object.source_code.name
      }
    }
  }

  service_config {
    min_instance_count    = 1
    max_instance_count    = 2
    available_memory      = "512Mi"
    timeout_seconds       = 3600
    service_account_email = google_service_account.functions.email
  }
}

# 権限
resource "google_cloudfunctions2_function_iam_member" "invoker" {
  project        = google_cloudfunctions2_function.main.project
  location       = google_cloudfunctions2_function.main.location
  cloud_function = google_cloudfunctions2_function.main.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:${google_service_account.functions.email}"
}

resource "google_cloud_run_service_iam_member" "cloud_run_invoker" {
  project  = google_cloudfunctions2_function.main.project
  location = google_cloudfunctions2_function.main.location
  service  = replace(google_cloudfunctions2_function.main.name, "_", "-")
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.functions.email}"
}


# schedulerの作成
resource "google_cloud_scheduler_job" "main" {
  name             = "invoke-gcp-query-error-trapping"
  schedule         = "0 * * * *" # 0, 60分に実行
  project          = var.project
  region           = var.region
  time_zone        = "Asia/Tokyo"
  attempt_deadline = "1800s"

  http_target {
    uri         = google_cloudfunctions2_function.main.service_config[0].uri
    http_method = "GET"
    oidc_token {
      audience              = "${google_cloudfunctions2_function.main.service_config[0].uri}/"
      service_account_email = google_service_account.functions.email
    }
  }
}
