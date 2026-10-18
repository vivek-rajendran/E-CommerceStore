data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ecommerce_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.ecommerce_subnet.id
  vpc_security_group_ids = [aws_security_group.ecommerce_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io docker-compose-v2
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu

              mkdir -p /home/ubuntu/app
              cd /home/ubuntu/app

              cat << 'DOCKER_COMPOSE' > docker-compose.yml
              version: '3.8'
              services:
                user-service:
                  image: viv01rajendran/ecommerce-user-service:latest
                  ports:
                    - "3001:3001"
                  environment:
                    - PORT=3001
                    - MONGODB_URI="${var.mongo_uri}"
                  restart: always

                product-service:
                  image: viv01rajendran/ecommerce-product-service:latest
                  ports:
                    - "3002:3002"
                  environment:
                    - PORT=3002
                    - MONGODB_URI="${var.mongo_uri}"
                  restart: always

                cart-service:
                  image: viv01rajendran/ecommerce-cart-service:latest
                  ports:
                    - "3003:3003"
                  environment:
                    - PORT=3003
                    - MONGODB_URI="${var.mongo_uri}"
                    - PRODUCT_SERVICE_URL=http://product-service:3002
                  restart: always

                order-service:
                  image: viv01rajendran/ecommerce-order-service:latest
                  ports:
                    - "3004:3004"
                  environment:
                    - PORT=3004
                    - MONGODB_URI="${var.mongo_uri}"
                    - CART_SERVICE_URL=http://cart-service:3003
                    - PRODUCT_SERVICE_URL=http://product-service:3002
                    - USER_SERVICE_URL=http://user-service:3001
                  restart: always

                frontend-service:
                  image: viv01rajendran/ecommerce-frontend:latest
                  ports:
                    - "3000:80"
                  restart: always
              DOCKER_COMPOSE

              docker compose pull
              docker compose up -d
              EOF

  tags = {
    Name = "ECommerce-Microservices-Server"
  }
}