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

echo "Building Docker image: ${REPO}:${TAG}"
docker build -t "${REPO}:${TAG}" .
docker tag "${REPO}:${TAG}" "${REPO}:latest"

echo "Build complete: ${REPO}:${TAG} and ${REPO}:latest"
