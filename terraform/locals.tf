locals {
  image_api = "${data.aws_ecr_repository.api.repository_url}:${var.tag_version}"
  image_courses = "${data.aws_ecr_repository.courses.repository_url}:${var.tag_version}"
  image_bcknd = "${data.aws_ecr_repository.bcknd.repository_url}:${var.tag_version}"
}
