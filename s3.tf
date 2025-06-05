terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.99.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}

# 1) Create the S3 bucket (no ACLs yet; default PublicAccessBlock is ON)
resource "aws_s3_bucket" "example_bucket" {
  bucket = "my-static-website-bucket-golguppev2"   # ← must be globally unique
  tags = {
    Name = "terraform-s3-static-hosting"
    Env  = "demo"
  }
}

# 2) Turn off ALL Public Access Blocks so we can attach ACLs later
resource "aws_s3_bucket_public_access_block" "example_public_block" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  # Ensure this runs immediately after bucket creation
  depends_on = [
    aws_s3_bucket.example_bucket
  ]
}

# 3) Enable Object Ownership = ObjectWriter (i.e. allow ACLs)
resource "aws_s3_bucket_ownership_controls" "example_ownership" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }

  # Must wait until public_block is disabled
  depends_on = [
    aws_s3_bucket_public_access_block.example_public_block
  ]
}

# 4) Now that public ACLs are unblocked AND ownership controls allow ACLs,
#    attach a bucket-level public-read ACL
resource "aws_s3_bucket_acl" "example_acl" {
  bucket = aws_s3_bucket.example_bucket.id
  acl    = "public-read"

  # Ensure OwnershipControls is already in place
  depends_on = [
    aws_s3_bucket_ownership_controls.example_ownership
  ]
}

# 5) Enable static website hosting
resource "aws_s3_bucket_website_configuration" "example_website" {
  bucket = aws_s3_bucket.example_bucket.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }

  # This can run in parallel with public_block/ownership if you like,
  # but if you ever see the same “blocked by public access” error,
  # you could also add a depends_on here:
  depends_on = [
    aws_s3_bucket_public_access_block.example_public_block,
    aws_s3_bucket_ownership_controls.example_ownership
  ]
}

# 6) Create a local index.html file to upload
resource "local_file" "index" {
  content  = <<EOF
<html>
  <head><title>Welcome</title></head>
  <body><h1>Static site powered by Terraform</h1></body>
</html>
EOF
  filename = "${path.module}/index.html"
}

# 7) Upload index.html as a public-read object (only AFTER bucket ACL is in place)
resource "aws_s3_object" "index_object" {
  bucket       = aws_s3_bucket.example_bucket.id
  key          = "index.html"
  source       = local_file.index.filename
  acl          = "public-read"
  content_type = "text/html"

  depends_on = [
    aws_s3_bucket_acl.example_acl
  ]
}
