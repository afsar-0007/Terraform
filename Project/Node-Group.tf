resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.node_role.arn

  subnet_ids = aws_subnet.private[*].id

  instance_types = [var.instance_type]

  scaling_config {
    desired_size = var.node_count
    max_size     = 3
    min_size     = 3
  }

  capacity_type = "ON_DEMAND"

  update_config {
    max_unavailable = 1
  }

  launch_template {
    name = aws_launch_template.node_template.name
    version = aws_launch_template.node_template.latest_version
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.worker_cni_policy,
    aws_iam_role_policy_attachment.worker_ecr_policy,
    aws_eks_cluster.eks
  ]

  tags = {
    Name = "${var.cluster_name}-worker-node"
  }
}

resource "aws_launch_template" "node_template" {
  name = "${var.cluster_name}-node-template"

  vpc_security_group_ids = [
    aws_security_group.node_sg.id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.cluster_name}-worker"
    }
  }
}