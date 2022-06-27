resource "aws_eks_cluster" "cluster-eks" {
 name = "eks-cluster"
 role_arn = "arn:aws:iam::007518468067:role/LabRole"
 vpc_config {
  subnet_ids = [aws_subnet.subnet-ms-az-a.id, aws_subnet.subnet-ms-az-b.id]
 }
}



resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.cluster-eks.name
  node_group_name = "workernodes"
  node_role_arn  = "arn:aws:iam::007518468067:role/LabRole"
  subnet_ids   = [aws_subnet.subnet-ms-az-a.id, aws_subnet.subnet-ms-az-b.id]
  instance_types = ["t3.xlarge"]
 
  scaling_config {
   desired_size = 2
   max_size   = 2
   min_size   = 2
  }
}