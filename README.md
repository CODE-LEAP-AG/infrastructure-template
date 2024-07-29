# Infrastructure Template
Version: 1.6.0

Author: Thinh Nguyen

## Version update (1.6.0)
- Created sample NestJS application
- Created CI/CD to deploy NestJS application to Kubernetes

## Motivation
This template makes use of monorepo approach to create a common sample codebase. 

It can also by used as a reference for initialization stage to start a project more quickly and in a consistent way.
## Template structure
```
.
├── .github/
│   ├── actions/
│   └── workflows/
├── infrastructure/
│   ├── docker/
│   ├── helm-chart/
│   └── terraform/
│       ├── core/
│       ├── modules/
│       └── ops/
├── backend/
├── frontend/
└── README.md
```
## Tech stack
- Docker
- Terraform with Azure
- GitHub Actions
## To make it works
This project uses Service Principal (App Registration) to authenticate Terraform to perform provisioning resources.

__Step 1: Create an App Registration on Azure__

On Azure Portal, create an App Registration named `<your-project-name>`. 

Under Manage -> Certificates & secrets -> Federated credentials, add a crendentials for GitHub Actions to use this App.

__Step 2: Grant Permission for App Registration__

On Azure Portal, open Subscription that will be used to deploy resources.

Under Access control (IAM) -> Add -> Add role assigment, in the Priviledged adminstrator roles, choose Owner. Next step, select the App Registration `<your-project-name>` that created above as your User.

Now that App Registration `<your-project-name>` has Owner permission on the subscription.

__Step 3: Create GitHub Secrets__

There are at least 3 compulsory information you need to create to make GitHub Actions works:
- client_id
- subscription_id
- tenant_id

We don't need `client_secret` here because we already authenticated GitHub Actions in step #1.

In GitHub repository settings, create these 3 secrets with their corresponding values:
- AZURE_CLIENT_ID
- AZURE_SUBSCRIPTION_ID
- AZURE_TENANT_ID