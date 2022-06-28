variable "key" {}

resource "aws_eks_cluster" "cluster-eks" {
 name = "eks-cluster"
 role_arn = "arn:aws:iam::${var.aws_account}:role/LabRole"
 vpc_config {
  subnet_ids = [aws_subnet.subnet-ms-az-a.id, aws_subnet.subnet-ms-az-b.id]
  security_group_ids = [aws_security_group.Cluster-EKS-sg.id]
 }
}



resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.cluster-eks.name
  node_group_name = "workernodes"
  node_role_arn  = "arn:aws:iam::${var.aws_account}:role/LabRole"
  subnet_ids   = [aws_subnet.subnet-ms-az-a.id, aws_subnet.subnet-ms-az-b.id]
  instance_types = ["t3.xlarge"]
  remote_access {
    source_security_group_ids = [aws_security_group.ms-nodes-sg.id]
    ec2_ssh_key = var.key
  }   
  scaling_config {
   desired_size = 2
   max_size   = 2
   min_size   = 2
  }
}