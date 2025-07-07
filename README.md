# terraform-aws-basic-infra

# 🌐 Terraform AWS Infrastructure Project

## 👤 Author
**Skander Houidi**

## 📦 Project Overview

This project provisions a complete AWS infrastructure using Terraform. It includes a VPC with public and private subnets, a web server with Nginx, a Bastion host, a Load Balancer, an RDS MySQL database, and backup/logging via S3 and CloudWatch.

---

## 🧱 Architecture Components

### ✅ Network
- **VPC**: Custom VPC with CIDR `10.0.0.0/16`
- **Subnets**:
  - 2 public subnets (`10.0.1.0/24`, `10.0.4.0/24`)
  - 2 private subnets (`10.0.2.0/24`, `10.0.3.0/24`)
- **Internet Gateway** and **Route Tables** for public access

---

### 🖥️ EC2 Instances
- **Web Server**:
  - Deployed in a public subnet
  - Runs **Nginx**
  - Connected to the internet via Internet Gateway
  - Part of the ALB Target Group
- **Bastion Host**:
  - Deployed in a public subnet
  - SSH access only
  - Used to access private resources securely
- **IAM Role** attached to EC2:
  - Allows S3 access
  - Allows CloudWatch Logs access

---

### ⚙️ Load Balancer (ALB)
- **Application Load Balancer (ALB)** deployed in public subnets
- **Target Group** attached to EC2 Web Server
- **Listener** on port 80 (HTTP)

---

### 🗄️ RDS MySQL
- MySQL 8.0 instance
- Private subnets only (not publicly accessible)
- Secured with dedicated Security Group allowing EC2 access

---

### ☁️ S3 Bucket
- Used for:
  - EC2 file backups 
- Public access blocked
- Versioning enabled

---

### 📊 Monitoring
- **Amazon CloudWatch Agent** installed on EC2
- **Logs collected**: `cloudinit`
- IAM permissions provided via role and instance profile

---

## 🔒 Security
- Security Groups for EC2, ALB, RDS, and Bastion with least privilege
- Only necessary ports (22, 80, 3306) opened
- Bastion host restricts SSH access