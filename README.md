# PDC ECS Fargate Project

This starter builds:
- ECS Fargate service behind an Application Load Balancer
- RDS PostgreSQL database
- ECR repository
- S3 bucket hosting donut SVG images
- A Flask app that seeds the database on first run
- A GitHub Actions workflow that builds the Docker image and forces a new ECS deployment

## Deploy steps
1. Fill in AWS credentials.
2. `cd infra`
3. Copy `../terraform.tfvars.example` to `terraform.tfvars` if you want overrides.
4. Run `terraform init`
5. Run `terraform apply`
6. Push the app to GitHub main so the workflow builds and pushes the Docker image.
7. Open the ALB URL from Terraform outputs.

## Files to present for the rubric
- `infra/main.tf` and friends = IaC
- `.github/workflows/deploy.yml` = pipeline
- `app/` = Flask app in Python
- `app/templates/index.html` = polished front end
