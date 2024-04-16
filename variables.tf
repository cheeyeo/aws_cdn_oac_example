variable "aws_s3_bucket" {
  type        = string
  description = "Name of S3 bucket to set as CDN origin"
}

variable "aws_s3_log_bucket" {
  type        = string
  description = "Name of S3 bucket to use as CDN logging"
}

variable "aws_s3_log_prefix" {
  type        = string
  default     = "myprefix"
  description = "Prefix for logs within aws_s3_log_bucket"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Region to host CDN"
}

variable "origin_name" {
  type        = string
  default     = "MYS3ID"
  description = "Name of origin within CDN"
}

variable "enable_cdn" {
  type        = bool
  default     = true
  description = "Whether to enable/disable the CDN"
}

variable "prebuilt_policy_name" {
    type = string
    default = ""
    description = "Name of prebuilt cache policy to use e.g. Managed-CachingOptimized"
}