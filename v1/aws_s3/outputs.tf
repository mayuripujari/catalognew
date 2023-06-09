//output for s3 bucket url
output "aws_s3_bucket-url" {
  value = aws_s3_bucket.bucket.bucket_domain_name
  
}

// output for an static website url
output "static-website-url" {
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
  # value = "This is the url for the static website hosted on aws s3" 
  value = aws_s3_bucket.bucket.website_endpoint
}