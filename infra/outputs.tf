output "load_balancer_url" {
  value = "http://${aws_lb.app.dns_name}"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "asset_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}

output "database_endpoint" {
  value = aws_db_instance.db.address
}
