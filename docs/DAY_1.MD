---
marp: true
---

#### Note

- First for the `vpc module`, we'll have 3 files, `main`, the `output`, and the `variables`

- The `variables.tf` will be the input, with description and default value, you can also declare your variable type if you want
- The `outputs.tf` one will be the result (I'm not using this yet)
- The `main.tf` will contains the code for configuring the aws resources
---


#### Syntax

```
resource [module] [local_variable_name] {
    <!-- [input value] -->
}
```

#### Example

```ts
resource "aws_vpc" "main" {
    cidr_block = var.cidr
    tags = {
      Name = "${var.vpc_name}-${var.environment}"
      Environment = var.environment
    }
}
```
---

#### CIDR
- so you can see that the `cidr_block` will use the cidr in the `modules/vpc/variables.tf`

- after that we will have `aws_vpc.main` variables in local and it could be use like this

```ts
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block        = element(var.private_subnets, count.index)
    availability_zone = element(var.availability_zones, count.index)
    count = length(var.private_subnets)

    tags = {
        Name = "${var.vpc_name}-${var.environment}-private-${count.index}"
        Environment = var.environment
    }
}
```
---

#### Slide 5
    - CIDR is very `important`

#### Example

    - `10.0.0.0/16` contains more than `60k` ip address
    - `10.0.1.0/24` contains only `256` ips