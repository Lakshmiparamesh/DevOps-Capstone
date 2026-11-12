# DevOps Capstone Project

End-to-end DevOps pipeline that deploys a React application to AWS EC2 using Docker, Jenkins CI/CD, bash automation, and open-source monitoring.

## Architecture

```
GitHub (Push) → Jenkins Pipeline → Docker Build → DockerHub → Docker Compose (EC2)
                                                                    ↓
                                                    Prometheus + Grafana (Monitoring)
```

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Application | React (OnlineShop e-commerce app) |
| Containerization | Docker + Docker Compose |
| CI/CD | Jenkins (Declarative Pipeline) |
| Infrastructure | AWS EC2 (t2.micro), Terraform |
| Web Server | Nginx 1.25 Alpine |
| Monitoring | Prometheus, Grafana, Node Exporter |
| Scripting | Bash (build.sh, deploy.sh) |
| Version Control | Git + GitHub |

## Project Structure

```
DevOps-Capstone/
├── Dockerfile                 # Multi-stage build with nginx:1.25-alpine
├── docker-compose.yml         # Container orchestration
├── nginx.conf                 # Nginx config for SPA routing
├── Jenkinsfile                # 5-stage declarative pipeline
├── build.sh                   # Docker build script with branch detection
├── deploy.sh                  # Docker push and deploy script
├── build/                     # React production build
├── terraform/
│   ├── main.tf                # AWS provider configuration
│   ├── variables.tf           # Variable definitions
│   ├── ec2.tf                 # EC2 instance (Ubuntu 22.04, t2.micro)
│   ├── security-groups.tf     # Ingress rules (SSH, HTTP, Jenkins, monitoring)
│   └── outputs.tf             # Instance IP, URLs
├── screenshots/               # Execution evidence screenshots
└── EXECUTION-OUTPUT.md        # Detailed execution documentation
```

## CI/CD Pipeline

The Jenkins pipeline has 5 stages:

1. **Checkout** — Clones the repository from GitHub
2. **Determine Branch** — Detects the branch and selects the target DockerHub repo
3. **Docker Build** — Builds the image tagged with the commit SHA
4. **Docker Push** — Pushes image to the appropriate DockerHub repository
5. **Deploy** — Runs `docker compose up` and performs a health check

### Branch-Based Routing

| Branch | DockerHub Repository |
|--------|---------------------|
| `main` / `master` | `lakshmiparamesh/devops-capstone-prod` |
| `dev` / other | `lakshmiparamesh/devops-capstone-dev` |

## Infrastructure

### AWS Resources (Terraform)

- **EC2 Instance:** t2.micro, Ubuntu 22.04 LTS, 20GB gp3 storage
- **Security Group:** SSH (restricted to admin IP), HTTP (80), Jenkins (8080), Prometheus (9090), Grafana (3000)
- **Region:** ap-south-1 (Mumbai)

### Ports

| Port | Service |
|------|---------|
| 80 | React Application (Nginx) |
| 8080 | Jenkins |
| 9090 | Prometheus |
| 9100 | Node Exporter |
| 3000 | Grafana |

## Monitoring

- **Prometheus** — Scrapes metrics from Node Exporter and itself
- **Node Exporter** — Collects CPU, memory, disk, and network metrics
- **Grafana** — Visualizes metrics with a custom EC2 Node Monitoring dashboard (CPU, Memory, Disk, Network panels)

## Setup Instructions

### Prerequisites
- AWS account with EC2 access
- Terraform installed
- Docker Hub account
- SSH key pair

### Deploy

```bash
# 1. Clone the repository
git clone https://github.com/Lakshmiparamesh/DevOps-Capstone.git
cd DevOps-Capstone

# 2. Provision infrastructure with Terraform
cd terraform
terraform init
terraform apply

# 3. SSH into the EC2 instance
ssh -i devops-capstone-key.pem ubuntu@<EC2_PUBLIC_IP>

# 4. Access services
# Application:  http://<EC2_PUBLIC_IP>
# Jenkins:      http://<EC2_PUBLIC_IP>:8080
# Prometheus:   http://<EC2_PUBLIC_IP>:9090
# Grafana:      http://<EC2_PUBLIC_IP>:3000
```

### Start Monitoring (stopped by default to save memory)

```bash
sudo systemctl start prometheus node_exporter grafana-server
```

## Screenshots

See [EXECUTION-OUTPUT.md](EXECUTION-OUTPUT.md) for all execution screenshots including:
- Jenkins pipeline stages and build console
- DockerHub repositories with pushed images
- Live deployed application
- Prometheus targets and metrics graphs
- Grafana monitoring dashboard
