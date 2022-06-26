

resource "aws_ecr_repository" "online-boutique" {
  name                 = "online-boutique"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
