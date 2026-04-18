terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  access_key = "AKIASVLKB7MLCWXVX2EY"
  secret_key = "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"
}

data "aws_caller_identity" "current" {}
data "aws_vpc" "default" {
  default = true
}
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
  name          = var.project_name
  subnet_ids    = slice(data.aws_subnets.default.ids, 0, 2)
  image_base_url = "https://${aws_s3_bucket.assets.bucket}.s3.${var.aws_region}.amazonaws.com"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "random_password" "db" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "${local.name}-db-password-${random_id.suffix.hex}"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db.result
}

resource "aws_s3_bucket" "assets" {
  bucket        = "${var.project_name}-assets-${random_id.suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket                  = aws_s3_bucket.assets.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "assets_public_read" {
  bucket = aws_s3_bucket.assets.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.assets.arn}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.assets]
}

resource "aws_s3_object" "donut_1" {
  bucket       = aws_s3_bucket.assets.id
  key          = "donut-1.svg"
  content_type = "image/svg+xml"
  content = <<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512">
  <rect width="512" height="512" rx="64" fill="#fff7ed"/>
  <circle cx="256" cy="256" r="170" fill="#d97706"/>
  <circle cx="256" cy="256" r="75" fill="#fff7ed"/>
  <circle cx="165" cy="165" r="18" fill="#fff7ed"/>
  <circle cx="345" cy="155" r="18" fill="#fff7ed"/>
  <circle cx="365" cy="330" r="18" fill="#fff7ed"/>
  <circle cx="175" cy="350" r="18" fill="#fff7ed"/>
  <path d="M132 255c42-72 90-108 124-108 35 0 58 40 108 40 28 0 49-11 56-20-1 71-13 120-55 162-41 41-96 63-149 63-44 0-83-14-115-37 16-22 22-45 31-100z" fill="#fb7185" opacity="0.45"/>
</svg>
SVG
}

resource "aws_s3_object" "donut_2" {
  bucket       = aws_s3_bucket.assets.id
  key          = "donut-2.svg"
  content_type = "image/svg+xml"
  content = <<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512">
  <rect width="512" height="512" rx="64" fill="#f8fafc"/>
  <circle cx="256" cy="256" r="170" fill="#8b5cf6"/>
  <circle cx="256" cy="256" r="75" fill="#f8fafc"/>
  <path d="M115 220c70-60 146-84 206-84 42 0 72 8 96 20-3 88-46 162-117 206-58 35-124 43-190 22-24-47-19-112 5-164z" fill="#22c55e" opacity="0.45"/>
  <circle cx="165" cy="165" r="16" fill="#f8fafc"/>
  <circle cx="344" cy="176" r="16" fill="#f8fafc"/>
  <circle cx="354" cy="332" r="16" fill="#f8fafc"/>
  <circle cx="176" cy="346" r="16" fill="#f8fafc"/>
</svg>
SVG
}

resource "aws_s3_object" "donut_3" {
  bucket       = aws_s3_bucket.assets.id
  key          = "donut-3.svg"
  content_type = "image/svg+xml"
  content = <<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512">
  <rect width="512" height="512" rx="64" fill="#f0f9ff"/>
  <circle cx="256" cy="256" r="170" fill="#ec4899"/>
  <circle cx="256" cy="256" r="75" fill="#f0f9ff"/>
  <path d="M108 246c58-93 140-132 217-125 58 5 97 32 129 76-14 75-51 136-116 176-64 40-136 40-204 6-18-35-20-84-26-133z" fill="#fde047" opacity="0.55"/>
  <circle cx="171" cy="167" r="18" fill="#f0f9ff"/>
  <circle cx="341" cy="163" r="18" fill="#f0f9ff"/>
  <circle cx="359" cy="337" r="18" fill="#f0f9ff"/>
  <circle cx="175" cy="345" r="18" fill="#f0f9ff"/>
</svg>
SVG
}

resource "aws_s3_object" "donut_4" {
  bucket       = aws_s3_bucket.assets.id
  key          = "donut-4.svg"
  content_type = "image/svg+xml"
  content = <<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512">
  <rect width="512" height="512" rx="64" fill="#fff1f2"/>
  <circle cx="256" cy="256" r="170" fill="#14b8a6"/>
  <circle cx="256" cy="256" r="75" fill="#fff1f2"/>
  <path d="M129 185c51-32 102-49 156-49 60 0 110 16 159 49-13 84-59 153-139 193-67 33-126 30-181 9-20-49-19-107 5-201z" fill="#fb923c" opacity="0.6"/>
  <circle cx="162" cy="173" r="17" fill="#fff1f2"/>
  <circle cx="347" cy="173" r="17" fill="#fff1f2"/>
  <circle cx="353" cy="338" r="17" fill="#fff1f2"/>
  <circle cx="175" cy="344" r="17" fill="#fff1f2"/>
</svg>
SVG
}

resource "aws_ecr_repository" "app" {
  name                 = "${var.project_name}-app"
  image_tag_mutability  = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7
}

resource "aws_iam_role" "ecs_execution" {
  name = "${var.project_name}-ecs-execution-${random_id.suffix.hex}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_managed" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_execution_secret_access" {
  name = "${var.project_name}-ecs-secret-access"
  role = aws_iam_role.ecs_execution.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = [aws_secretsmanager_secret.db_password.arn]
      }
    ]
  })
}

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP to ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-ecs-sg"
  description = "Allow app traffic from ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "Allow PostgreSQL from ECS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "${var.project_name}-db-subnets-${random_id.suffix.hex}"
  subnet_ids = local.subnet_ids
}

resource "aws_db_instance" "db" {
  identifier              = "${var.project_name}-db-${random_id.suffix.hex}"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp3"
  db_name                 = var.db_name
  username                = var.db_username
  password                = random_password.db.result
  port                    = 5432
  publicly_accessible     = false
  multi_az                = false
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0
  apply_immediately       = true
  storage_encrypted       = true
  db_subnet_group_name    = aws_db_subnet_group.db.name
  vpc_security_group_ids   = [aws_security_group.db.id]
}

resource "aws_lb" "app" {
  name               = substr("${var.project_name}-alb-${random_id.suffix.hex}", 0, 32)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = local.subnet_ids
}

resource "aws_lb_target_group" "app" {
  name        = substr("${var.project_name}-tg-${random_id.suffix.hex}", 0, 32)
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_ecs_cluster" "app" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "${aws_ecr_repository.app.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "DATABASE_HOST", value = aws_db_instance.db.address },
        { name = "DATABASE_PORT", value = tostring(aws_db_instance.db.port) },
        { name = "DATABASE_NAME", value = var.db_name },
        { name = "DATABASE_USER", value = var.db_username },
        { name = "IMAGE_BASE_URL", value = local.image_base_url },
      ]
      secrets = [
        {
          name      = "DATABASE_PASSWORD"
          valueFrom = aws_secretsmanager_secret.db_password.arn
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  depends_on      = [aws_lb_listener.http]

  network_configuration {
    subnets          = local.subnet_ids
    security_groups   = [aws_security_group.ecs.id]
    assign_public_ip  = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "app"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}
