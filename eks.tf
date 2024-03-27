#allowing eks assume roles in eks services 
resource "aws_iam_role" "eks" {
  name = "eks-cluster-eks"

  assume_role_policy = <<POLICY
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
POLICY
}

#Specify to iam role grant the permission to eks clustr#
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

#name of the cluster#
resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks_cluster"
  role_arn = aws_iam_role.eks.arn
#create 2 public & 2 private subnet for eks
  vpc_config {
    subnet_ids = [
      aws_subnet.private-ap-south-1a.id,
      aws_subnet.private-ap-south-1b.id,
      aws_subnet.public-ap-south-1a.id,
      aws_subnet.public-ap-south-1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy]
}