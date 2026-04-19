#!/bin/bash

# Test scenario: archlinux
# Tests Conan installation on Arch Linux latest

set -e

source dev-container-features-test-lib

check "conan is installed" command -v conan
check "conan --version" bash -c "conan --version"

reportResults
