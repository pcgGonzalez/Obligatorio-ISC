

resource "aws_ecr_repository" "online-boutique" {
  name                 = "online-boutique"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
output "ecr_url" {
  description = "URL del Repositorio en ECR llamado online-boutique"
  value = aws_ecr_repository.online-boutique.repository_url
}

