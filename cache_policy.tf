# Compression cache policy
resource "aws_cloudfront_cache_policy" "compression" {
  count = length(var.prebuilt_policy_name) > 0 ? 0 : 1
  name        = "compression-policy"
  comment     = "Compresses assets from origin"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
      cookies {
        items = []
      }
    }

    headers_config {
      header_behavior = "none"
      headers {
        items = []
      }
    }

    query_strings_config {
      query_string_behavior = "none"
      query_strings {
        items = []
      }
    }

    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}