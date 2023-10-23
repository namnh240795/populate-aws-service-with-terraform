resource "aws_s3_bucket" "s3bucket" {
  bucket = "${var.bucket_name}"
  tags = {
    Name        = "${var.environment}-bucket-${var.bucket_name}"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "s3bucket_acl" {
  bucket = aws_s3_bucket.s3bucket.id
  acl = "private"
}

resource "aws_cloudfront_function" "multilingual" {
  name = "multilingual"
  comment = "Multilingual redirect function"
  code = file("${path.module}/multilingual.js")
  runtime = "cloudfront-js-1.0"
  publish = true
}

// create a new public request certificate for domain https://resume.yellowcandle.party
resource "aws_acm_certificate" "cert" {
  domain_name = "resume.yellowcandle.party"
  validation_method = "DNS"
}

resource "aws_cloudfront_response_headers_policy" "s3bucket_cache_response_header" {
  name = "s3bucket_cache_response_header"
  custom_headers_config {
    items {
      header = "Cache-Control"
      value = "max-age=86400;"
      override = true
    }
  }
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "bucket_distribution" {
  origin {
    domain_name = aws_s3_bucket.s3bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.s3bucket.id
  }

  price_class = "PriceClass_200"
  enabled = true
  tags = {
    Environment = var.environment
  }
  is_ipv6_enabled = true
  http_version = "http2"
  wait_for_deployment = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.s3bucket.id


    cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized.id
    
    response_headers_policy_id = aws_cloudfront_response_headers_policy.s3bucket_cache_response_header.id

    compress = true

    function_association {
      event_type = "viewer-request"
      function_arn = aws_cloudfront_function.multilingual.arn
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }
}
