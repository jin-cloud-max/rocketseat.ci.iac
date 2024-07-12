resource "aws_iam_openid_connect_provider" "oidc-github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "a031c46782e6e6c662c2c87c76da9aa62ccabd8e"
  ]

  tags = {
    IaC       = "True"
    CreatedBy = "Terraform"
  }

}

resource "aws_iam_role" "tf-role" {
  name = "tf-role"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "sts:AssumeRoleWithWebIdentity",
        Principal : {
          Federated : "arn:aws:iam::566529662008:oidc-provider/token.actions.githubusercontent.com"
        },
        Condition : {
          StringEquals : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" : "repo:jin-cloud-max/rocketseat.ci.iac:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = {
    IaC       = "True"
    CreatedBy = "Terraform"
  }
}


resource "aws_iam_role" "ecr-role" {
  name = "ecr-role"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "sts:AssumeRoleWithWebIdentity",
        Principal : {
          Federated : "arn:aws:iam::566529662008:oidc-provider/token.actions.githubusercontent.com"
        },
        Condition : {
          StringEquals : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" : "repo:jin-cloud-max/rocketseat.ci.api:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  inline_policy {
    name = "ecr-app-permissions"
    policy = jsonencode({
      Statement = [
        {
          Sid      = "Statement1"
          Action   = "apprunner:*"
          Effect   = "Allow",
          Resource = "*"
        },
        {
          Sid = "Statement2"
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:GetAuthorizationToken",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Sid = "Statement3"
          Action = [
            "iam:PassRole",
            "iam:CreateServiceLinkedRole",
          ]
          Effect   = "Allow",
          Resource = "*"
        }
      ]
    })
  }

  tags = {
    IaC       = "True"
    CreatedBy = "Terraform"
  }
}

resource "aws_iam_role" "app-runner-role" {
  name = "app-runner-role"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Service : "build.apprunner.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]

  tags = {
    IaC       = "True"
    CreatedBy = "Terraform"
  }
}