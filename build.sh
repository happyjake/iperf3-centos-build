#!/bin/bash

# Build the Docker image
docker build -t iperf3:latest .

# Create a new container from the image
docker create --name temp_container iperf3:latest

# Copy the binary from the container to the host
docker cp temp_container:/usr/local/bin/iperf3 ./iperf3

# Remove the temporary container
docker rm temp_container
