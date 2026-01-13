#!/bin/bash

# 1. Check if Docker is installed via snap
if ! snap list docker &> /dev/null; then
    echo "Docker not found. Installing via snap..."
    sudo snap install docker
    sudo addgroup --system docker
    sudo adduser $USER docker
    echo "Docker installed."
else
    echo "Docker is already installed."
fi

# 2. Check if Semaphore container is already running
if [ "$(sudo docker ps -q -f name=semaphore)" ]; then
    echo "Semaphore is already running."
elif [ "$(sudo docker ps -aq -f name=semaphore)" ]; then
    echo "Semaphore container exists but is stopped. Starting it..."
    sudo docker start semaphore
else
    echo "Semaphore not found. Deploying new container..."
    # Deploying with your custom credentials
    sudo docker run -d \
      --name semaphore \
      -p 3000:3000 \
      -e SEMAPHORE_ADMIN=cdo \
      -e SEMAPHORE_ADMIN_PASSWORD=bb123#123 \
      -e SEMAPHORE_ADMIN_NAME="CDO Admin" \
      -e SEMAPHORE_ADMIN_EMAIL=admin@localhost \
      -e SEMAPHORE_DB_DIALECT=bolt \
      semaphoreui/semaphore:latest
    
    echo "Semaphore deployed! Access it at http://localhost:3000"
    echo "Username: cdo"
    echo "Password: bb123#123"
fi