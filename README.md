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



