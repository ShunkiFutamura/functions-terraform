variable "projects" {
  type = string
  default = "hgym-340203"
}
variable "service_account_id" {
  type = string
  default = "bq-storage-function"
}
variable "gcs_bucket" {
  type = string
  default = "terraform-functions-machine-anomaly-bucket"
}
variable "gcs_file_name" {
  type = string
  default = "terraform-functions"
}
variable "functions_name" {
  type = string
  default = "functions-terraform"
}
variable "functions_description" {
  type = string
  default = "terraformで起動したfunctions"
}
variable "scheduler_name" {
  type = string
  default = "invoke-functions-terraform"
}
variable "scheduler_description" {
  type = string
  default = "Schedule the HTTPS trigger for cloud function"
}
variable "scheduler_duration" {
  type = string
  default = "0 1 * * *"
}
