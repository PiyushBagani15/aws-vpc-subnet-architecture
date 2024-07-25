#
# AWS VPC Subnet Architecture

This repository provides Terraform configurations for setting up a secure AWS VPC environment with multiple subnets, route tables, and network access control lists. It is designed to facilitate quick deployment of a VPC with considerations for security and modularity.

## Features
- **VPC Creation**: Configures a VPC with defined CIDR blocks.
- **Subnet Management**: Establishes multiple subnets to segregate network traffic.
- **Routing**: Implements route tables for effective network traffic management.
- **Access Control**: Uses network ACLs to control inbound and outbound traffic.

## Prerequisites
- Terraform installed on your machine.
- AWS account and AWS CLI configured with necessary permissions.

## Usage
1. **Clone the repository**:
   ```
   git clone https://github.com/PiyushBagani15/aws-vpc-subnet-architecture
   ```
2. **Initialize Terraform**:
   ```
   terraform init
   ```
3. **Apply the Terraform configurations**:
   ```
   terraform apply
   ```

## File Descriptions
- `aws_networking.tf`: Contains all networking resources like VPC, subnets, route tables, etc.
- `variables.tf`: Defines the variables used in Terraform configurations.
- `outputs.tf`: Defines outputs after Terraform execution.

## Contributing
I want you to know that contributions to enhance this architecture are welcome. Please fork the repository and submit pull requests with your modifications.

## Contact
Piyush Bagani - [GitHub Profile](https://github.com/PiyushBagani15)

## Acknowledgments
- AWS documentation
- Terraform community
