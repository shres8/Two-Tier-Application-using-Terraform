 # 🌐 Two-Tier Application on AWS using Terraform

## Architecture Diagram
![architecture](https://github.com/user-attachments/assets/811bba8d-c2c9-407a-a962-92f82d21941d)

## 📘 Overview

This project automates the deployment of a **highly available and scalable two-tier architecture** on **Amazon Web Services (AWS)** using **Terraform**.
This project automates the deployment of a highly available, secure, and scalable two-tier web application architecture on AWS using Terraform. It provisions complete infrastructure including VPC, NAT gateways, ALB, ASG, RDS, CloudFront, and Route 53. The setup ensures dynamic scaling, secure networking, and global content delivery with automated DNS and SSL integration. It's designed for production-grade reliability and modular infrastructure management.

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


## ▶️ How to Run

1. **Install Terraform** and configure AWS CLI with credentials.
2. **Clone the repo** and navigate to the project directory.
3. **Set variables** in `terraform.tfvars` or via CLI.
4. **Initialize Terraform**:
   ```bash
   terraform init
   terraform apply
   ```

## ☁️ Remote Backend Configuration

This project uses a **remote backend** to manage Terraform state files securely and collaboratively.

terraform {
  backend "s3" {
    bucket         = "tf-state-shres8-101"
    key            = "backend/project.tfstate"
    region         = "us-east-1"
    dynamodb_table = "remote-backend"
  }
}


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


## 🌐 NAT Gateway and Private Routing

This section configures **Elastic IPs**, **NAT Gateways**, and **private route tables** to enable outbound internet access for private subnets.

### 🔧 Resources Created

- **Elastic IPs**:
  - `eip-nat-a`: For NAT Gateway in `pub_sub_1a`
  - `eip-nat-b`: For NAT Gateway in `pub_sub_2b`

- **NAT Gateways**:
  - `nat-a`: Located in `pub_sub_1a`, uses `eip-nat-a`
  - `nat-b`: Located in `pub_sub_2b`, uses `eip-nat-b`
  - Both depend on the Internet Gateway to ensure proper provisioning order.

- **Private Route Tables**:
  - `pri-rt-a`: Routes traffic from private subnets `pri_sub_3a` and `pri_sub_4b` through `nat-a`
  - `pri-rt-b`: Routes traffic from private subnets `pri_sub_5a` and `pri_sub_6b` through `nat-b`

- **Route Table Associations**:
  - `pri_sub_3a` and `pri_sub_4b` → `pri-rt-a`
  - `pri_sub_5a` and `pri_sub_6b` → `pri-rt-b`

### 📌 Highlights

- Ensures private subnets have secure outbound internet access via NAT.
- Distributes NAT gateways across availability zones for high availability.
- Explicit `depends_on` used to maintain resource creation order.


## 🔐 Security Groups Configuration

This section defines security groups for the Application Load Balancer (ALB), client EC2 instances, and the database layer to enforce secure and controlled traffic flow.

### 🔧 Resources Created

- **ALB Security Group (`alb_sg`)**:
  - Allows inbound HTTP (port 80) and HTTPS (port 443) traffic from anywhere (`0.0.0.0/0`)
  - Allows all outbound traffic

- **Client Security Group (`client_sg`)**:
  - Allows inbound HTTP traffic (port 80) from the ALB security group
  - Allows all outbound traffic

- **Database Security Group (`db_sg`)**:
  - Allows inbound MySQL traffic (port 3306) from the client security group
  - Allows all outbound traffic

### 📌 Highlights

- Security groups are tightly scoped to allow only necessary traffic between layers.
- Uses `security_groups` references to enforce inter-group communication.
- Ensures public access only to the ALB, while internal layers remain protected.


## 🔑 Key Pair Configuration

This section provisions an **AWS Key Pair** to enable secure SSH access to EC2 instances.

### 🔧 Resource Created

- **Key Pair (`client_key`)**:
  - Name: `client_key`
  - Public key is sourced from the local file path: `../modules/key/client_key.pub`

### 📌 Highlights

- The key pair is used to authenticate SSH access to client EC2 instances.
- Ensure the corresponding private key is securely stored and accessible only to authorized users.
- The public key must be in OpenSSH format and correctly placed in the specified path.

> ⚠️ Keep your private key secure and never commit it to version control.


## ⚖️ Application Load Balancer (ALB) Configuration

This section provisions an **Application Load Balancer** to distribute incoming traffic across EC2 instances in multiple availability zones.

### 🔧 Resources Created

- **ALB (`application_load_balancer`)**:
  - Public-facing (not internal)
  - Type: `application`
  - Attached to public subnets: `pub_sub_1a` and `pub_sub_2b`
  - Secured by the ALB security group
  - Deletion protection disabled

- **Target Group (`alb_target_group`)**:
  - Target type: `instance`
  - Protocol: HTTP on port 80
  - Health check configured to monitor `/` path with HTTP 200 response
  - Lifecycle rule ensures safe replacement (`create_before_destroy`)

- **Listener (`alb_http_listener`)**:
  - Listens on port 80 using HTTP
  - Forwards traffic to the target group

### 📌 Highlights

- Ensures high availability by spanning multiple availability zones.
- Health checks improve reliability by monitoring instance health.
- Listener configuration enables dynamic traffic routing to healthy targets.


## 🚀 Auto Scaling Group (ASG) and Launch Template

This section sets up a **Launch Template**, an **Auto Scaling Group**, and **CloudWatch alarms** to ensure dynamic scaling of EC2 instances based on CPU utilization.

### 🔧 Resources Created

- **Launch Template (`lt_name`)**:
  - Uses a specified AMI and instance type
  - Injects a startup script via `user_data`
  - Associates the EC2 instance with the client security group

- **Auto Scaling Group (`asg_name`)**:
  - Spans private subnets `pri_sub_3a` and `pri_sub_4b`
  - Uses the launch template for instance configuration
  - Registers instances with the ALB target group
  - Configured with min, max, and desired capacity
  - Publishes key metrics at 1-minute granularity

- **Scaling Policies**:
  - **Scale Up**: Adds 1 instance when CPU ≥ 70%
  - **Scale Down**: Removes 1 instance when CPU ≤ 5%

- **CloudWatch Alarms**:
  - Trigger scale-up or scale-down actions based on average CPU utilization over 2 evaluation periods

### 📌 Highlights

- Ensures high availability and cost-efficiency by scaling based on demand
- Launch template simplifies instance provisioning and updates
- CloudWatch alarms automate scaling decisions for optimal performance


## 🗄️ Amazon RDS Configuration

This section provisions a **MySQL database** using Amazon RDS, hosted in private subnets for enhanced security.

### 🔧 Resources Created

- **DB Subnet Group (`db-subnet`)**:
  - Includes private subnets `pri_sub_5a` and `pri_sub_6b`
  - Ensures the database is deployed across multiple availability zones

- **RDS Instance (`db`)**:
  - Identifier: `bookdb-instance`
  - Engine: MySQL 5.7
  - Instance type: `db.t2.micro`
  - Allocated storage: 20 GB (General Purpose SSD - gp2)
  - Multi-AZ deployment enabled for high availability
  - Not publicly accessible (private subnet only)
  - No final snapshot on deletion
  - Backup retention: 0 days (can be adjusted)
  - Secured with the `db_sg` security group

### 📌 Highlights

- Database is isolated in private subnets for security.
- Multi-AZ ensures fault tolerance and high availability.
- Credentials and DB name are parameterized via variables.
- Skips final snapshot for faster teardown in dev/test environments.

> 🔐 Make sure to manage database credentials securely and avoid hardcoding sensitive values.


## 🌍 CloudFront Distribution & SSL Configuration

This section sets up a **CloudFront distribution** to serve content globally with low latency and secure HTTPS access using an ACM-issued SSL certificate.

### 🔧 Resources Created

- **ACM Certificate (`issued`)**:
  - Retrieves an existing SSL certificate for the specified domain
  - Must be in `ISSUED` status

- **CloudFront Distribution (`my_distribution`)**:
  - Enabled for global content delivery
  - Uses the ALB domain as the origin
  - Configured with custom origin settings (HTTP-only, TLSv1.2)
  - Viewer protocol policy: `redirect-to-https`
  - Caching behavior:
    - Allows all HTTP methods
    - Caches `GET`, `HEAD`, and `OPTIONS`
    - Forwards all cookies and query strings
  - Geo-restriction:
    - Whitelisted countries: India (IN), United States (US), Canada (CA)
  - SSL Configuration:
    - Uses ACM certificate with `sni-only` support
    - Minimum protocol version: `TLSv1.2_2018`

### 📌 Highlights

- Enhances performance and security with global CDN and HTTPS redirection.
- Integrates seamlessly with ALB as the origin.
- Restricts access to specific geographic regions.
- Uses ACM for secure and managed certificate provisioning.

> 🌐 Make sure your domain is correctly validated in ACM before deploying CloudFront.


## 🌐 Route 53 DNS Configuration

This section sets up a **DNS record** in AWS Route 53 to map a custom domain to the CloudFront distribution.

### 🔧 Resources Created

- **Route 53 Hosted Zone (`public-zone`)**:
  - Fetches the public hosted zone using the domain name provided in `var.hosted_zone_name`

- **DNS Record (`cloudfront_record`)**:
  - Type: `A` (Alias record)
  - Name: `project.<your-domain>`
  - Points to the CloudFront distribution using:
    - `cloudfront_domain_name` (e.g., `d1234.cloudfront.net`)
    - `cloudfront_hosted_zone_id` (typically `Z2FDTNDATAQYW2` for CloudFront)

### 📌 Highlights

- Uses alias record for seamless integration with CloudFront (no IP address required)
- Automatically resolves to the correct CloudFront endpoint
- Ensures secure and performant routing via AWS DNS infrastructure

> 📝 Make sure your domain is correctly registered and validated in Route 53 before applying this configuration.


## ⚠️ Limitations

While this project demonstrates a robust and scalable infrastructure setup, there are a few limitations to consider:

- **Hardcoded Parameters**: Some values (e.g., subnet CIDRs, instance types, scaling thresholds) are statically defined and may require manual updates for different environments.
- **No CI/CD Integration**: The project does not include automated deployment pipelines or integration with tools like Jenkins, GitHub Actions, or Terraform Cloud.
- **Limited Monitoring & Logging**: Basic CloudWatch alarms are configured, but advanced monitoring, centralized logging, and alerting are not included.
- **Single Region Deployment**: The infrastructure is deployed in a single AWS region, which may not be sufficient for global failover or disaster recovery.
- **No Secrets Management**: Database credentials and other sensitive values are passed via variables without integration with AWS Secrets Manager or SSM Parameter Store.

> These limitations can be addressed in future iterations to make the setup more production-ready and secure.
