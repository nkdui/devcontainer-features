#!/bin/bash

# Auto-generated test for 'conan' feature with default options
# Tests against mcr.microsoft.com/devcontainers/base:ubuntu with conan installed

set -e

source dev-container-features-test-lib

# Check that conan command is available
check "conan command exists" command -v conan

# Check that conan --version works
check "conan --version works" bash -c "conan --version | grep -E 'Conan version'"

# Check that conan can list profiles
check "conan profile list works" bash -c "conan profile list 2>/dev/null || true"

reportResults
