resource "aws_iam_role" "eks_iam_role" {
    name = "eks_iam_role_cluster"
    
   assume_role_policy = <<EOF
 {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
 EOF 
}

resource "aws_iam_role_policy_attachment" "Cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_iam_role.name
}

resource "aws_iam_role_policy_attachment" "Service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = aws_iam_role.eks_iam_role.name
}

resource "aws_iam_role" "eks_iam_role_worker" {
    name = "eks-iam-role-workerNode"
   assume_role_policy = <<POLICY
 {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
 POLICY
}

resource "aws_iam_role_policy_attachment" "worker" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks_iam_role_worker.name
}

resource "aws_iam_role_policy_attachment" "CNI" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks_iam_role_worker.name
}

resource "aws_iam_role_policy_attachment" "Container" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks_iam_role_worker.name
}