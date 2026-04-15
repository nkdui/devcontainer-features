#!/bin/sh
set -e

echo "Activating feature 'conan'"

# Get options from environment variables (capitalized as per spec)
CONAN_VERSION="${CONANVERSION:-latest}"
USER_HOME="${USERHOME:-/root}"

echo "Installing Conan version: ${CONAN_VERSION}"
echo "User home directory: $USER_HOME"

# Detect the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID"
    echo "Detected distribution: $DISTRO"
else
    echo "ERROR: Cannot detect distribution. /etc/os-release not found."
    exit 1
fi

# Function to check if Python is installed
distro_check() {
    echo "Checking Python installation..."
    if command -v python3 >/dev/null 2>&1; then
        echo "Python3 is already installed"
        return 0
    fi
    echo "Python3 not found. Installing..."
    return 1
}

install_python_debian() {
    apt-get update
    apt-get install -y --no-install-recommends python3 python3-venv
}

install_python_arch() {
    pacman -Sy --noconfirm python
}

install_python_fedora() {
    dnf install -y python3
}

# Install Python based on distro
if ! distro_check; then
    case "$DISTRO" in
        debian|ubuntu)
            install_python_debian
            ;;
        arch|archlinux)
            install_python_arch
            ;;
        fedora)
            install_python_fedora
            ;;
        *)
            echo "ERROR: Unsupported distribution: $DISTRO"
            echo "Supported distributions: debian, ubuntu, arch, fedora"
            exit 1
            ;;
    esac
fi

# Verify Python is available
if ! command -v python3 >/dev/null 2>&1; then
    echo "ERROR: python3 command not found after installation"
    exit 1
fi

# Create a global virtual environment for Conan
CONAN_VENV_DIR="/opt/conan-venv"
echo "Creating global virtual environment at $CONAN_VENV_DIR..."
python3 -m venv "$CONAN_VENV_DIR"

# Install Conan in the virtual environment
if [ "$CONAN_VERSION" = "latest" ]; then
    echo "Installing latest Conan..."
    "$CONAN_VENV_DIR/bin/pip" install --upgrade conan
else
    echo "Installing Conan version $CONAN_VERSION..."
    "$CONAN_VENV_DIR/bin/pip" install conan=="$CONAN_VERSION"
fi

# Create symlinks to make conan available globally
ln -sf "$CONAN_VENV_DIR/bin/conan" /usr/local/bin/conan

# Verify installation
if command -v conan >/dev/null 2>&1; then
    INSTALLED_VERSION=$(conan --version 2>&1 | head -n1)
    echo "Successfully installed: $INSTALLED_VERSION"
else
    echo "ERROR: Conan installation failed. 'conan' command not found."
    exit 1
fi

# Make the virtual environment accessible to all users
chmod -R a+rX "$CONAN_VENV_DIR"

# Create Conan home directory if it doesn't exist
if [ ! -d "$USER_HOME/.conan2" ] && [ ! -d "$USER_HOME/.conan" ]; then
    echo "Setting up Conan home directory..."
    mkdir -p "$USER_HOME/.conan2"
    chown -R "$_REMOTE_USER:$_REMOTE_USER" "$USER_HOME/.conan2" 2>/dev/null || true
fi

echo "Conan feature activation complete!"
