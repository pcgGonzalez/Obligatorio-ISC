resource "aws_instance" "IMG-Builder" {
  ami                    = "ami-09a41e26df464c548"
  instance_type          = "t2.micro"
  key_name		 = "vockey"
  root_block_device {
    volume_type 	 = "gp3"
    volume_size		 = 30
  }
  vpc_security_group_ids = [aws_security_group.ms-sg.id]
  subnet_id = aws_subnet.SUBNET_1.id
  associate_public_ip_address = true
  tags = {
    Name = "IMG-Builder"
  }


  connection {
    type     = "ssh"
    user     = "admin"
    private_key = file("/home/lx/Escritorio/labsuser.pem")
    host = self.public_ip
  }

  provisioner "file" {
    source      = "/home/lx/Escritorio/Obligatorio/WorkSpace/Codigo-Terraform/start_script.sh"
    destination = "/home/admin/start_script.sh"
  }

  provisioner "file" {
    source      = "/home/lx/.aws"
    destination = "/home/admin/.aws"
  }

   provisioner "file" {
    source      = "/home/lx/Escritorio/Obligatorio/WorkSpace/Codigo-Terraform/online-boutique"
    destination = "/home/admin/online-boutique"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/admin/start_script.sh",
       "/home/admin/start_script.sh",
    ]
  }

    depends_on = [
    aws_eks_cluster.cluster-eks
  ]
}