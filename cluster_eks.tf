resource "aws_eks_cluster" "cluster-eks" {
 name = "eks-cluster"
 role_arn = "arn:aws:iam::897373788973:role/LabRole"
 vpc_config {
  subnet_ids = [aws_subnet.SUBNET_1.id, aws_subnet.SUBNET_2.id]
 }

}



resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.cluster-eks.name
  node_group_name = "workernodes"
  node_role_arn  = "arn:aws:iam::897373788973:role/LabRole"
  subnet_ids   = [aws_subnet.SUBNET_1.id, aws_subnet.SUBNET_2.id]
  instance_types = ["t3.xlarge"]
 
  scaling_config {
   desired_size = 1
   max_size   = 1
   min_size   = 1
  }
}
