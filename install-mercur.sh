#!/bin/bash
# Auto-install script for mercur-cli
# This answers the prompts automatically

export PROJECT_NAME="mercur-store"
export DB_HOST="postgres"
export DB_PORT="5432"
export DB_USER="postgres"
export DB_PASSWORD="medusajs"
export DB_NAME="medusa"
export INSTALL_STOREFRONT="n"
export INSTALL_VENDOR_PANEL="n"

# Run mercur-cli install with automated responses
echo -e "${PROJECT_NAME}\n${DB_HOST}\n${DB_PORT}\n${DB_USER}\n${DB_PASSWORD}\n${DB_NAME}\n${INSTALL_STOREFRONT}\n${INSTALL_VENDOR_PANEL}\n" | npx mercur-cli@latest install
