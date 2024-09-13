variable "project" {}
variable "project_number" {}
variable "region" {}

variable "functions_name" {
  description = "functionsの名前"
  default     = ""
}
variable "function_description" {
  description = "functionsの説明文"
  default     = ""
}
variable "function_runtime" {
  description = "functionsのランタイム環境(3.11)"
  default     = "python311"
}
variable "bucket_name" {
  description = "functionsのソースコードを格納するバケット名"
  default     = ""
}
variable "source_dir" {
  description = "functionsのソースコードが格納されているディレクトリ"
  type        = string
  default     = "../functions/src"
}
variable "output_path" {
  description = "functionsの圧縮ファイルの出力先"
  type        = string
  default     = "../code.zip"
}
