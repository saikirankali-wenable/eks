resource "aws_eks_cluster" "cluster_first" {
    name = "eks-cluster-first"
    role_arn = aws_iam_role.eks_iam_role.arn
   


   

    vpc_config {
        security_group_ids = [ aws_security_group.worker.id ]
        subnet_ids = [ aws_subnet.worker[*].id]
    }


    depends_on = [ 
        aws_iam_role_policy_attachment.Cluster,
        aws_iam_role_policy_attachment.Service
     ]
}


resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.cluster_first.name
  node_group_name = "eks-node-grp"
  node_role_arn   = aws_iam_role.eks_iam_role_worker.arn
  subnet_ids      = aws_subnet.worker[*].id
  instance_types = ["t2.micro"]
  scaling_config {
    desired_size = var.desired-capacity
    max_size     = var.max-size
    min_size     = var.min-size
  }

  
  depends_on = [
    aws_iam_role_policy_attachment.worker,
    aws_iam_role_policy_attachment.CNI,
    aws_iam_role_policy_attachment.Container
  ]
  tags = {
    Name = "first-eks-node-group"
  }
}
