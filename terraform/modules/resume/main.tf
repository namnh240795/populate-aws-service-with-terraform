resource "aws_s3_bucket" "s3bucket" {
  bucket = "${var.bucket_name}"
  tags = {
    Name        = "${var.environment}-bucket-${var.bucket_name}"
    Environment = var.environment
  }
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

// create new cloudfront distribution for s3bucket with above domain
