---
marp: true
title: XYZ
---

# To day we will deploy ec2 with terraform

- First let's generate new ssh key

* Make new directory and go into it
```sh
    mkdir .ssh && cd .ssh
```

* Generate new aws_tf with this syntax
```sh
    ssh-keygen -t ed25519
```
---

# Now create firewall rules to allow connection to aws ec2 instance

```ts
    resource "aws_security_group" "ec2_to_internet" {
    name        = "${var.vpc_name}-${var.environment}-allow-http"
    description = "Allow HTTP inbound traffic"
    vpc_id      = aws_vpc.main.id

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }
}
```
---

# Note about the syntax
- `egress`: the request going out of the ec2
- `ingress`: the request going to the ec2
- `cidr` will allow ip address to reach `ec2`
- `protocol` -1 mean any protocal
---

# TODO: IT IS TOO LATE FOR ME NOW