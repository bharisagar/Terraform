#!/bin/bash
set -euo pipefail

LOG="/tmp/deploy.log"

{
  echo "========================================"
  echo "  DEPLOYMENT STARTED: $(date)"
  echo "  Hostname: $(hostname)"
  echo "========================================"
} | tee -a "$LOG"

echo "[1/4] Updating system packages..." | tee -a "$LOG"
sudo dnf update -y >> "$LOG" 2>&1

echo "[2/4] Installing nginx web server..." | tee -a "$LOG"
sudo dnf install -y nginx >> "$LOG" 2>&1

echo "[3/4] Starting nginx..." | tee -a "$LOG"
sudo systemctl enable --now nginx >> "$LOG" 2>&1

echo "[4/4] Writing app homepage..." | tee -a "$LOG"
sudo tee /usr/share/nginx/html/index.html >/dev/null <<HTML
<!DOCTYPE html>
<html>
<head><title>Terraform Provisioner Demo</title></head>
<body style="font-family: Arial; text-align: center; padding: 50px; background: #f0f4f8;">
  <h1 style="color: #1e3a8a;">Terraform Provisioner Demo</h1>
  <p>This page was deployed by Terraform provisioners.</p>
  <p>Server: <strong>$(hostname)</strong></p>
  <p>Deployed at: <strong>$(date)</strong></p>
</body>
</html>
HTML

{
  echo "========================================"
  echo "  DEPLOYMENT COMPLETE: $(date)"
  echo "  Visit: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
  echo "========================================"
} | tee -a "$LOG"
