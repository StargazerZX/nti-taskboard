#!/usr/bin/env bash
set -euo pipefail

# Display usage information if argument count is incorrect
if [ "$#" -ne 1 ]; then
    echo "Error: Missing application file argument."
    echo "Usage: $0 <application-file>"
    exit 1
fi

APP_FILE="$1"

# Verify that the specified application file exists
if [ ! -f "$APP_FILE" ]; then
    echo "Error: Application file '$APP_FILE' does not exist."
    exit 1
fi

# Ensure required CLI tools are installed
echo "===> Checking prerequisites..."
command -v helm >/dev/null 2>&1 || { echo "Error: 'helm' is not installed or not in PATH."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "Error: 'kubectl' is not installed or not in PATH."; exit 1; }

# Add and update the Argo Helm repository to ensure 'argo/argo-cd' is available on Minikube or EKS
echo "===> Adding/Updating Argo Helm repository..."
helm repo add argo https://argoproj.github.io/argo-helm --force-update >/dev/null 2>&1 || true
helm repo update >/dev/null 2>&1

# Install or upgrade Argo CD
echo "===> Installing/Upgrading Argo CD..."
helm upgrade --install argocd argo/argo-cd -n argocd --create-namespace --wait

# Apply the target application manifest
echo "===> Applying application file: $APP_FILE..."
kubectl apply -f "$APP_FILE"

echo "===> Successfully installed Argo CD and applied $APP_FILE!"