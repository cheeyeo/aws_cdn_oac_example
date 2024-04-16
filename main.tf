terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.52.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_s3_bucket" "selected" {
  bucket = var.aws_s3_bucket
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront_only" {
  bucket = data.aws_s3_bucket.selected.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront_only.json
}

data "aws_iam_policy_document" "allow_access_from_cloudfront_only" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${data.aws_s3_bucket.selected.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "S3Assets"
  description                       = "S3 Assets CDN Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Gets the AWS managed cache policy
data "aws_cloudfront_cache_policy" "caching_optimized" {
  count = length(var.prebuilt_policy_name) > 0 ? 1 : 0
  name = var.prebuilt_policy_name
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    # DNS of bucket
    domain_name              = data.aws_s3_bucket.selected.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = var.origin_name
  }

  enabled = var.enable_cdn

  logging_config {
    include_cookies = false
    bucket          = "${var.aws_s3_log_bucket}.s3.amazonaws.com"
    prefix          = var.aws_s3_log_prefix
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.origin_name
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    # Uses AWS Prebuilt caching optimized policy
    # cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized[0].id
    cache_policy_id = length(var.prebuilt_policy_name) > 0 ? data.aws_cloudfront_cache_policy.caching_optimized[0].id : aws_cloudfront_cache_policy.compression[0].id
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "dev"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}