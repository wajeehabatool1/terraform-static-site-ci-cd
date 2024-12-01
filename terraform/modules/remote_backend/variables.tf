variable "user_name" {
  description = "user for terraform"
  type        = string
}
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}
variable "table_name" {
  description = "dynamodb table to store states"
  type        = string
}