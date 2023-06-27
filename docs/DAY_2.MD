---
marp: true
---

#### VPC
- VPC => Virtual Network
- Subnets: Range of ip address in VPC
- Can deploy resources after we have the subnets
---


#### Subnet
- So today we will make the public vpc have the access to the internet

- Step 1: Create Public Route Table And Internet Gateway
- Step 2: Connect the route table with the public subnet
- Step 3: Connect the route table with the internet gate way
---

#### Note
Basically everything has the public subnet will be available on the internet.
- Internet gateway allow instances (load balancer, ec2) with public IPS to access the internet

- Yeah but we have one more problem 
- That we need a firewall but for now just create new ec2 without any rules
- Notes: Need to Allow Access from internet to your instance via security groups inbound rules
