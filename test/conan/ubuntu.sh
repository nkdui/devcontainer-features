#!/bin/bash

# Test scenario: default
# Tests Conan installation on Ubuntu with default options

set -e

source dev-container-features-test-lib

check "conan installed" command -v conan
check "conan version works" bash -c "conan --version"

reportResults
