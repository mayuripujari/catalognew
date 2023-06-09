provider "aws" {
  region = "us-east-2"
  profile = "default"
  shared_credentials_file = ".aws/credentials"
  

}

# Generate a random string to keep names unique
resource "random_string" "random" {
  length  = 5
  special = false
  lower   = true
  upper   = false
}


locals {
  deployment_id     = var.deploymentid
  bucket-name       = random_string.random.result
  mod-bucket-name   = "${local.deployment_id}-${local.bucket-name}"
  staticwebsite_url = aws_s3_bucket.bucket.website_endpoint
  s3-bucket_url     = aws_s3_bucket.bucket.bucket_domain_name
}


//creating bucket with an random name
resource "aws_s3_bucket" "bucket" {
  bucket = local.mod-bucket-name
  #  acl = "public-read"
  versioning {
    enabled = false
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = merge(var.tags, {
    Name        = "My Bucket"
    Environment = "Dev"
  })


}
//Upload files inside s3 bucket
resource "aws_s3_bucket_object" "object" {
  for_each     = fileset(path.module, "**/*.html")
  bucket       = aws_s3_bucket.bucket.bucket
  key          = each.value
  source       = "${path.module}/${each.value}"
  content_type = "text/html"
}


resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}


resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.bucket.id


  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_ownership_controls,
    aws_s3_bucket_public_access_block.bucket_public_access_block,
  ]


  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"
}


//configure bucket policy
resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.public.json
}


data "aws_iam_policy_document" "public" {

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:ListBucket",
      "s3:ListBucketVersions",
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*",
      "arn:aws:s3:::${aws_s3_bucket.bucket.id}"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

