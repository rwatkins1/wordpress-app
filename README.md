Overview

This project provides a guided approach to deploying a Wordpress application using IaC tool. The deployment process sets up necessary infrastructure on AWS, including security groups, a custom vpc, Amazon RDS database, and ec2 instance. After the initial deployment, some manual configuration steps are required to complete the setup of the EC2 instance to host the Wordpress application. 

https://github.com/user-attachments/assets/d132c06f-a8e8-4868-aaa1-d206b3f51d41

Prerequisites
Before you begin, ensure you have the following:

Terraform: Installed on your local machine. Follow the official installation guide.
AWS CLI: Installed and configured with your AWS credentials. 
AWS Account: An active AWS account with the necessary permissions to create resources.
SSH Key Pair: An SSH key pair for accessing the EC2 instance.

.
├── main.tf                    # Main Terraform configuration file

├── variables.tf               # Input variables for the Terraform script

├── outputs.tf                 # Outputs of the Terraform deployment

├── ec2.tf                     # EC2 instance configuration

├── securitygroups.tf          # Security group configurations

├── database.tf                # RDS instance configuration for MySQL

└── README.md                  # Documentation

Deployment Steps
1. Clone the Repository
Clone this repository to your local machine:
git clone https://github.com/your-username/wordpress-terraform-deployment.git
cd wordpress-terraform-deployment

2. Edit Terraform Files
Before deploying the infrastructure, you will need to edit the Terraform files directly to configure your AWS region, SSH key name, database credentials, and other variables.

3. Initialize Terraform
Initialize the Terraform workspace:
terraform init

4. Plan the Deployment
Review the resources that will be created by running:
terraform plan

5. Deploy the Infrastructure
Apply the Terraform configuration to create the infrastructure:
terraform apply

6.  SSH into the EC2 Instance
After the deployment, you will need to SSH into the EC2 instance to configure it for hosting the WordPress application.

7. Post-Deployment EC2 Configuration
After SSH'ing into the EC2 instance, you need to configure it to host the WordPress application. Follow these steps:

1. Create the HTML Directory
sudo su
yum update -y
mkdir -p /var/www/html

2. Install Apache
sudo yum install -y httpd httpd-tools mod_ssl
sudo systemctl enable httpd 
sudo systemctl start httpd

3. Install PHP 7.4
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install php php-common php-pear -y
sudo yum install php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip} -y

4. Install MYSQL 
sudo rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum install mysql-community-server -y
sudo systemctl enable mysqld
sudo systemctl start mysqld

## If you see an error here run:
sudo rpm --import repo.mysql.com/RPM-GPG-KEY-mysql-2023 

https://stackoverflow.com/questions/71239450/gpg-keys-issue-while-installing-mysql-community-server

5. Set Permissions
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
sudo find /var/www -type f -exec sudo chmod 0664 {} \;
sudo chown apache:apache -R /var/www/html

6. Download Wordpress
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/

7. Create the wp-config.php File
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

8. Edit the wp-config.php File
vi /var/www/html/wp-config.php
Update the database connection details with the appropriate values for DB_NAME, DB_USER, DB_PASSWORD, and DB_HOST.

9. Restart the web serber
sudo service httpd restart

Enter the IP address into a web browser and you should be able to configure wordpress. 

<img width="1263" alt="Screen Shot 2024-08-14 at 8 48 11 AM" src="https://github.com/user-attachments/assets/18ba0851-9305-4769-9379-882a210555fa">

Configuration Details
VPC and Subnets: A VPC with 2 public and 4 private subnets are created.
Security Groups: Security groups are configured to allow HTTP traffic and secure database connections.
EC2 Instance: The EC2 instance runs the WordPress application.
RDS Instance: An RDS instance running MySQL is set up as the backend database for WordPress.

Potential Next Steps
1. Load Balancing:
Implement an AWS Elastic Load Balancer (ELB) to distribute traffic across multiple EC2 instances, improving the application's scalability and fault tolerance.

2. HTTPS Configuration:
Secure the WordPress site by configuring HTTPS using SSL/TLS certificates, potentially utilizing AWS Certificate Manager (ACM) and integrating with the load balancer.

3. Custom Domain with Route 53:
Set up a custom domain for the WordPress site using Amazon Route 53 for DNS management, including setting up DNS records and potentially configuring subdomains.

4. Elastic File System (EFS) Integration:
Enhance the storage solution by integrating Amazon EFS, allowing multiple EC2 instances to share the same file system.

5. Highly Available Architecture:
Deploying WordPress across multiple availability zones, using an auto-scaling group to manage the EC2 instances, and ensuring the RDS instance is configured with multi-AZ deployment for database redundancy.
These steps were intentionally left off the initial project to keep the setup straightforward

Cleanup: 
To destroy the resources created by this project, run:
terraform destroy

