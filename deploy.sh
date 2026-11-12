#!/bin/bash
set -e

IMAGE_NAME="lakshmiparamesh/devops-capstone"
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "dev")
TAG=$(git rev-parse --short HEAD 2>/dev/null || echo "latest")

if [ "$BRANCH" = "master" ] || [ "$BRANCH" = "main" ]; then
    REPO="${IMAGE_NAME}-prod"
else
    REPO="${IMAGE_NAME}-dev"
fi

echo "Pushing image to DockerHub: ${REPO}:${TAG}"
docker push "${REPO}:${TAG}"
docker push "${REPO}:latest"

echo "Deploying application..."
docker compose down 2>/dev/null || true
docker compose up -d

echo "Deployment complete. Application running on port 80."
echo "Waiting for health check..."
sleep 5
curl -f http://localhost:80 > /dev/null 2>&1 && echo "Application is healthy!" || echo "Warning: Health check pending"
