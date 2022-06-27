variable "git_user" {}
variable "git_password" {}
variable "docker_user" {}
variable "docker_pwd" {}
variable "key" {}

resource "aws_instance" "IMG-Builder" {
  ami                    = "ami-09a41e26df464c548"
  instance_type          = "t2.micro"
  key_name		 = "aortega"
  depends_on = [
    aws_eks_cluster.cluster-eks
  ]
  root_block_device {
    volume_type 	 = "gp3"
    volume_size		 = 40
  }
  vpc_security_group_ids = [aws_security_group.pivot-sg.id]
  subnet_id = aws_subnet.subnet-pivot.id
  associate_public_ip_address = true
  tags = {
    Name = "IMG-Builder"
  }
  connection {
    type     = "ssh"
    user     = "admin"
    private_key = file("${var.key}")
    host = self.public_ip
  }

  provisioner "file" {
    source      = "start_script.sh"
    destination = "/home/admin/start_script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "export AWS_ACCESS_KEY_ID=${var.aws_access_key_id}",
      "export AWS_SECRET_ACCESS_KEY=${var.aws_secret_access_key}",
      "export AWS_SESSION_TOKEN=${var.aws_session_token}",
      "export AWS_DEFAULT_REGION=${var.aws_region}",
      "export GIT_USER=${var.git_user}",
      "export GIT_PWD=${var.git_password}",
      "export DOCKER_USER=${var.docker_user}",
      "export DOCKER_PWD=${var.docker_pwd}",
      "chmod +x /home/admin/start_script.sh",
      "/home/admin/start_script.sh",
    ]
  }
}
