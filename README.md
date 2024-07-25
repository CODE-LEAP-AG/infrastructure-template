# Infrastructure Template
Version: 0.1.0
Author: Thinh Nguyen

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
- Terraform
- GitHub Actions