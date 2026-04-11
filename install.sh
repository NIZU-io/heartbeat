#!/bin/bash
set -e

BINARY_NAME="nizu_heartbeat"
INSTALL_DIR="/usr/local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

BINARY_PATH="$SCRIPT_DIR/dist/$PLATFORM/$BINARY_NAME"

if [ ! -f "$BINARY_PATH" ]; then
  echo "Binary not found for platform '$PLATFORM': $BINARY_PATH"
  exit 1
fi

echo "Detected platform: $PLATFORM"
echo "Installing $BINARY_NAME to $INSTALL_DIR..."

install -m 755 "$BINARY_PATH" "$INSTALL_DIR/$BINARY_NAME"

echo "Done. Run '$BINARY_NAME' to get started."
