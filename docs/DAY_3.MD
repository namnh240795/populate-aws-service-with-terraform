---
marp: true
---

#### To day we will deploy ec2 with terraform

- First let's generate new ssh key

* Make new directory and go into it

```sh
    mkdir .ssh && cd .ssh
```

- Generate new aws_tf with this syntax

```sh
    ssh-keygen -t ed25519
```

---

#### Now create firewall rules to allow connection to aws ec2 instance

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

#### Note about the syntax

- `egress`: the request going out of the ec2
- `ingress`: the request going to the ec2
- `cidr` will allow ip address to reach `ec2`
- `protocol` -1 mean any protocal
- `0.0.0.0/0` mean everything can go in and go out

---

#### Now we need to set up the instance type

- lets set instance type to t2.micro

```ts
data "aws_ec2_instance_type" "t2_micro" {
    instance_type = "t2.micro"
}
```

---

#### Set up AWS Machine Image data

- after that we need to choose the aws_ami (ami stand for aws machine image like ubuntu, centos,...)

```ts
    data "aws_ami" "aws_ubuntu" {
        most_recent = true
        owners      = ["amazon"]


        filter {
            name   = "name"
            values = ["amzn-ami-hvm*"]
        }

        filter {
            name   = "root-device-type"
            values = ["ebs"]
        }

        filter {
            name   = "virtualization-type"
            values = ["hvm"]
        }
    }
```

---

#### Finally create the aws instance with this command

- Attach it to the public subnet so it is able to access from internet and returun the content

```ts
    resource "aws_instance" "ec2" {
        ami = data.aws_ami.aws_ubuntu.id
        instance_type = data.aws_ec2_instance_type.t2_micro.id
        key_name = aws_key_pair.ec2_key_pem.key_name
        vpc_security_group_ids = [aws_security_group.ec2_to_internet.id]
        subnet_id = element(aws_subnet.public.*.id, 0)
        associate_public_ip_address = true
        tags = {
            Name = "${var.vpc_name}-${var.environment}-ec2"
            Environment = var.environment
        }
    }
```
