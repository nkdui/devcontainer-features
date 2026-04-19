#!/bin/sh
set -e

echo "Activating feature 'conan' (1.x series only)"

CONAN_VERSION="${CONANVERSION:-latest}"
USER_HOME="${USERHOME:-/root}"
CONAN_VENV_DIR="/opt/conan-venv"

validate_version() {
    if [ "$CONAN_VERSION" = "latest" ]; then
        return
    fi
    MAJOR=$(echo "$CONAN_VERSION" | cut -d. -f1)
    if [ "$MAJOR" != "1" ]; then
        echo "ERROR: This feature only supports Conan 1.x. Requested version: $CONAN_VERSION"
        exit 1
    fi
}

get_installed_version() {
    if ! command -v conan > /dev/null 2>&1; then
        echo ""
        return
    fi
    RAW=$(conan --version 2>&1 | head -n1)
    echo "$RAW" | sed -n 's/.*version \([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p'
}

check_existing_conan() {
    INSTALLED=$(get_installed_version)
    
    if [ -z "$INSTALLED" ]; then
        echo "No existing Conan installation found."
        return
    fi
    
    MAJOR=$(echo "$INSTALLED" | cut -d. -f1)
    if [ "$MAJOR" != "1" ]; then
        echo "ERROR: Conan $INSTALLED is installed, but this feature requires Conan 1.x"
        exit 1
    fi
    
    if [ "$CONAN_VERSION" = "latest" ]; then
        echo "Conan 1.x already installed ($(conan --version 2>&1 | head -n1))"
        echo "Skipping installation."
        exit 0
    fi
    
    if [ "$INSTALLED" = "$CONAN_VERSION" ]; then
        echo "Conan $CONAN_VERSION is already installed. Skipping."
        exit 0
    fi
    
    echo "ERROR: Version conflict. Requested: $CONAN_VERSION, Installed: $INSTALLED"
    exit 1
}

detect_distribution() {
    if [ ! -f /etc/os-release ]; then
        echo "ERROR: Cannot detect distribution. /etc/os-release not found."
        exit 1
    fi
    . /etc/os-release
    echo "$ID"
}

install_python() {
    DISTRO=$(detect_distribution)
    echo "Detected distribution: $DISTRO"
    
    if command -v python3 > /dev/null 2>&1; then
        echo "Python3 is already installed"
        return
    fi
    
    echo "Installing Python3..."
    case "$DISTRO" in
        debian|ubuntu)
            apt-get update && apt-get install -y --no-install-recommends python3 python3-venv
            ;;
        arch|archlinux)
            pacman -Sy --noconfirm python
            ;;
        fedora)
            dnf install -y python3
            ;;
        alpine)
            apk add --no-cache python3 py3-pip
            ;;
        *)
            echo "ERROR: Unsupported distribution: $DISTRO"
            exit 1
            ;;
    esac
}

install_conan() {
    echo "Creating virtual environment at $CONAN_VENV_DIR..."
    python3 -m venv "$CONAN_VENV_DIR"
    
    if [ "$CONAN_VERSION" = "latest" ]; then
        echo "Installing latest Conan 1.x..."
        "$CONAN_VENV_DIR/bin/pip" install --upgrade "conan<2"
    else
        echo "Installing Conan $CONAN_VERSION..."
        "$CONAN_VENV_DIR/bin/pip" install "conan==$CONAN_VERSION"
    fi
    
    ln -sf "$CONAN_VENV_DIR/bin/conan" /usr/local/bin/conan
    chmod -R a+rX "$CONAN_VENV_DIR"
    
    if ! command -v conan > /dev/null 2>&1; then
        echo "ERROR: Conan installation failed"
        exit 1
    fi
    
    echo "Successfully installed: $(conan --version 2>&1 | head -n1)"
}

setup_conan_home() {
    if [ -d "$USER_HOME/.conan" ]; then
        return
    fi
    echo "Setting up Conan home directory at $USER_HOME/.conan..."
    mkdir -p "$USER_HOME/.conan"
    chown -R "$_REMOTE_USER:$_REMOTE_USER" "$USER_HOME/.conan" 2>/dev/null || true
}

validate_version
check_existing_conan
echo "Installing Conan ${CONAN_VERSION} (user home: $USER_HOME)"
install_python
install_conan
setup_conan_home

echo "Conan feature activation complete!"
