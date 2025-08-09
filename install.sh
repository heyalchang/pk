#!/usr/bin/env bash

set -e

REPO="https://github.com/alchang/pk"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="pk"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

error() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

info() {
    echo -e "${GREEN}$1${NC}"
}

warning() {
    echo -e "${YELLOW}$1${NC}"
}

# Check dependencies
command -v git >/dev/null 2>&1 || error "git is required but not installed"
command -v lsof >/dev/null 2>&1 || error "lsof is required but not installed"

# Create install directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Clone or update repository
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

info "Downloading pk..."
git clone --quiet --depth 1 "$REPO" "$TEMP_DIR" 2>/dev/null || error "Failed to clone repository"

# Install the script
info "Installing pk to $INSTALL_DIR..."
cp "$TEMP_DIR/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Check if install directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    warning "$INSTALL_DIR is not in your PATH"
    echo ""
    echo "Add this to your shell configuration file (.bashrc, .zshrc, etc):"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
fi

# Verify installation
if command -v pk >/dev/null 2>&1; then
    info "pk installed successfully."
    pk --version
else
    info "pk installed to $INSTALL_DIR/$SCRIPT_NAME"
    info "Run 'pk --version' after adding $INSTALL_DIR to your PATH"
fi