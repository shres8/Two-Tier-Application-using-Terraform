 # 🌐 Two-Tier Application on AWS using Terraform

## Architecture Diagram
![architecture](https://github.com/user-attachments/assets/811bba8d-c2c9-407a-a962-92f82d21941d)

## 📘 Overview

This project automates the deployment of a **highly available and scalable two-tier architecture** on **Amazon Web Services (AWS)** using **Terraform**.

## 🧩 Architecture Components

- **VPC**: Custom Virtual Private Cloud with public and private subnets  
- **NAT Gateway**: Enables internet access for private subnets  
- **Security Groups**: Fine-grained access control for EC2, RDS, and ALB  
- **Key Pair**: For secure SSH access to EC2 instances  
- **Application Load Balancer (ALB)**: Distributes traffic across EC2 instances  
- **Auto Scaling Group (ASG)**: Ensures high availability and scalability of the application tier  
- **Amazon RDS**: Managed relational database in the private subnet  
- **CloudFront**: CDN for faster content delivery  
- **Route 53**: DNS management for domain routing  

## 🛠️ Technologies Used

- **Terraform**  
- **AWS Services**: VPC, EC2, RDS, ALB, ASG, CloudFront, Route 53  
- **Linux/Ubuntu** (for EC2 instances)  
- **Shell scripting** (optional for provisioning)

## 🔐 Backend Details
- S3 Bucket: Stores the Terraform state file (project.tfstate)
- Key: Path within the bucket where the state file is stored
- Region: AWS region where the S3 bucket and DynamoDB table are located
- DynamoDB Table: Used for state locking and consistency to prevent concurrent modifications
## 🌐 VPC and Networking Configuration

This module sets up the foundational networking infrastructure for the two-tier application.

### 🔧 Resources Created

- **VPC**: Custom Virtual Private Cloud with DNS support and hostnames enabled.
- **Internet Gateway**: Attached to the VPC to allow internet access for public subnets.
- **Availability Zones**: Dynamically fetched using AWS data source.
- **Public Subnets**:
  - `pub_sub_1a` in the first availability zone
  - `pub_sub_2b` in the second availability zone
  - Both subnets have public IP mapping enabled.
- **Private Subnets**:
  - **Application Layer**:
    - `pri_sub_3a` in AZ1
    - `pri_sub_4b` in AZ2
  - **Database Layer**:
    - `pri_sub_5a` in AZ1
    - `pri_sub_6b` in AZ2
  - All private subnets have public IP mapping disabled.
- **Route Table**:
  - A public route table with a default route (`0.0.0.0/0`) pointing to the Internet Gateway.
  - Associated with both public subnets.

### 📌 Highlights

- Uses `aws_availability_zones` data source for dynamic zone selection.
- Ensures high availability by distributing subnets across multiple AZs.
- Public subnets are internet-facing; private subnets are isolated for app and DB layers.


