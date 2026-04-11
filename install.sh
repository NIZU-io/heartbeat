#!/bin/bash
set -e

BINARY_NAME="nizu_heartbeat"
INSTALL_DIR="/usr/local/bin"
REPO="NIZU-io/heartbeat"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH/dist"

# Detect OS
OS="$(uname -s)"
if [ "$OS" != "Linux" ]; then
  echo "Unsupported OS: $OS (only Linux is supported)"
  exit 1
fi

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)
    PLATFORM="linux_x86_64"
    ;;
  aarch64 | arm64)
    PLATFORM="linux_arm64"
    ;;
  armv7l | armv7)
    PLATFORM="linux_armv7"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

DOWNLOAD_URL="$BASE_URL/$PLATFORM/$BINARY_NAME"

echo "Detected platform: $PLATFORM"
echo "Downloading $BINARY_NAME from $DOWNLOAD_URL..."

TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

if command -v curl &>/dev/null; then
  curl -fsSL "$DOWNLOAD_URL" -o "$TMP_FILE"
elif command -v wget &>/dev/null; then
  wget -qO "$TMP_FILE" "$DOWNLOAD_URL"
else
  echo "Error: curl or wget is required"
  exit 1
fi

install -m 755 "$TMP_FILE" "$INSTALL_DIR/$BINARY_NAME"

echo "Done. Run '$BINARY_NAME' to get started."
