#!/bin/bash

# Auto-generated test for 'conan' feature with default options
# Tests against mcr.microsoft.com/devcontainers/base:ubuntu with conan installed

set -e

source dev-container-features-test-lib

check "conan is installed" command -v conan
check "conan --version" bash -c "conan --version"

reportResults
