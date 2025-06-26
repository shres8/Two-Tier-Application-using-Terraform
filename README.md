# Two-Tier-Application-using-Terraform

## Architecture Diagram
![architecture](https://github.com/user-attachments/assets/811bba8d-c2c9-407a-a962-92f82d21941d)

🌐 ## Two-Tier Application on AWS using Terraform
📘 ## Overview
This project automates the deployment of a highly available and scalable two-tier architecture on Amazon Web Services (AWS) using Terraform. It provisions a complete infrastructure stack including networking, compute, storage, and content delivery components.

🧩 ## Architecture Components
VPC: Custom Virtual Private Cloud with public and private subnets
NAT Gateway: Enables internet access for private subnets
Security Groups: Fine-grained access control for EC2, RDS, and ALB
Key Pair: For secure SSH access to EC2 instances
Application Load Balancer (ALB): Distributes traffic across EC2 instances
Auto Scaling Group (ASG): Ensures high availability and scalability of the application tier
Amazon RDS: Managed relational database in the private subnet
CloudFront: CDN for faster content delivery
Route 53: DNS management for domain routing

🛠️ Technologies Used
Terraform
AWS Services: VPC, EC2, RDS, ALB, ASG, CloudFront, Route 53
Linux/Ubuntu (for EC2 instances)
Shell scripting (optional for provisioning)

📦 Project Structure
.
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── modules/
│   ├── vpc/
│   ├── nat/
│   ├── security-group/
│   ├── key-pair/
│   ├── alb/
│   ├── asg/
│   ├── rds/
│   ├── cloudfront/
│   └── route53/
└── README.md
  backend "s3" {
    bucket = "BUCKET_NAME"
    key    = "backend/FILE_NAME_TO_STORE_STATE.tfstate"
    region = "us-east-1"
    dynamodb_table = "dynamoDB_TABLE_NAME"
  }
}
```
### Lets setup the variable for our Infrastructure
create one file with the name of `terraform.tfvars` 
```sh
vim book_shop_app/terraform.tfvars
```

add below contents into `book_shop_app/terraform.tfvars` file
```javascript
REGION                  = ""
PROJECT_NAME            = ""
VPC_CIDR                = ""
PUB_SUB_1_A_CIDR        = ""
PUB_SUB_2_B_CIDR        = ""
PRI_SUB_3_A_CIDR        = ""
PRI_SUB_4_B_CIDR        = ""
PRI_SUB_5_A_CIDR        = ""
PRI_SUB_6_B_CIDR        = ""
DB_USERNAME             = ""
DB_PASSWORD             = ""
CERTIFICATE_DOMAIN_NAME = ""
ADDITIONAL_DOMAIN_NAME  = ""


```

## ✈️ Now we are ready to deploy our application on cloud ⛅
get into project directory 
```sh
cd book_shop_app
```

type below command to see plan of the exection 
```sh
terraform plan
```

Finally, HIT the below command to deploy the application...
```sh
terraform apply 
```

type `yes`, it will prompt you for permission..

**Thank you so much for reading..**


