# Terraform Multi-Environment AWS Infrastructure

## 📌 Project Overview

This project uses **Terraform** to provision AWS infrastructure using a **single reusable Terraform codebase** for multiple environments.

The project currently supports:

- Development (`dev`)
- Production (`prod`)

Terraform Workspaces are used to maintain separate state for each environment, while environment-specific values are supplied using separate `.tfvars` files.

The infrastructure includes:

- Amazon VPC
- Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 instances
- Amazon S3 bucket
- S3 bucket versioning
- Terraform data sources
- Random S3 bucket suffix
- Terraform modules
- Environment-specific configuration

---

# 🏗️ Architecture

```text
                         TERRAFORM
                            │
                    Single Codebase
                            │
                            ▼
                  Terraform Workspace
                     ┌──────┴──────┐
                     │             │
                    DEV           PROD
                     │             │
                     ▼             ▼
              Environment      Environment
                 Values            Values
                     │             │
                     └──────┬──────┘
                            │
                            ▼
                       VPC Module
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
            VPC           Subnet      Route Table
                                           │
                                      Internet Gateway
                            │
              ┌─────────────┴─────────────┐
              │                           │
              ▼                           ▼
       Security Group                   S3
              │
              ▼
             EC2