# Micro-Ops Hackathon Solution

This repository contains the fully containerized microservices solution for the Micro-Ops Hackathon Challenge.

## Live Deployment

The application is deployed on Render and is accessible at:
https://hackathon-gateway.onrender.com

## Project Architecture

The solution implements a secure Gateway pattern:
1. Gateway Service (Public): Exposed on port 5921. Handles all incoming traffic.
2. Backend Service (Private): Runs on port 3847. Isolated within the Docker network and not accessible from the host machine.
3. Database (Private): MongoDB instance running on port 27017. Isolated and persistent.

## Prerequisites

- Docker
- Docker Compose
- Make (Optional, for using Makefile commands)

## How to Run Locally

You can start the application using Docker Compose directly or via the Makefile.

### Method 1: Using Docker Compose

Run the following command from the root directory:

docker-compose -f docker/compose.development.yaml up --build

### Method 2: Using Makefile

If you are on a Unix-based system or have Make installed:

make dev-up

## API Testing

Once the application is running, use the following commands to verify functionality:

1. Health Check
curl http://localhost:5921/api/health

2. Create a Product
curl -X POST http://localhost:5921/api/products \
  -H 'Content-Type: application/json' \
  -d '{"name":"Test Product","price":99.99}'

3. Get All Products
curl http://localhost:5921/api/products

## Key Features

- Containerization: Fully dockerized services using Docker Compose.
- Security: Implemented private networking where Backend and Database are hidden from the public network.
- Optimization: Used multi-stage Docker builds and Alpine-based images for reduced size.
- Data Persistence: Configured Docker Volumes to ensure data is preserved across container restarts.
- Configuration: Fixed port configurations to ensure seamless communication between Gateway and Backend.
- Automation: Included a comprehensive Makefile for easier development and deployment management.