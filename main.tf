# ------- Start: Create the AWS Prometheus Workspace -------
resource "aws_prometheus_workspace" "k6_performance_test" {
  alias = "k6_performance_test"
}
# ------- End: Create the AWS Prometheus Workspace -------


# ------- Start: Create/Setup the AWS Grafana Workspace -------
resource "aws_iam_role" "assume" {
  name = "grafana-assume"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "grafana_assume_role_policy" {
  role        = aws_iam_role.assume.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonPrometheusFullAccess"
}

resource "aws_grafana_workspace" "k6_performance_test" {
  name                     = "k6_performance_test"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  role_arn                 = aws_iam_role.assume.arn
  
  data_sources = ["PROMETHEUS"]
}

resource "aws_grafana_role_association" "grafana_user_association" {
  role         = "ADMIN"
  user_ids     = [var.ADMIN_GRAFANA_USER_ID]
  workspace_id = aws_grafana_workspace.k6_performance_test.id
}

# ------- End: Create/Setup the AWS Grafana Workspace -------