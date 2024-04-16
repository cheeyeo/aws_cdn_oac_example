output "cdn_url" {
  value       = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
  description = "URL of CDN"
}

output "cdn_arn" {
  value       = aws_cloudfront_distribution.s3_distribution.arn
  description = "ARN of CDN"
}

output "cdn_id" {
  value       = aws_cloudfront_distribution.s3_distribution.id
  description = "ID of CDN"
}

output "cdn_status" {
  value       = aws_cloudfront_distribution.s3_distribution.status
  description = "Current status of CDN"
}