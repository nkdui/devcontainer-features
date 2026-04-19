#!/bin/bash

# Test scenario: alpine
# Tests Conan installation on Alpine latest

set -e

source dev-container-features-test-lib

check "conan is installed" command -v conan
check "conan --version" bash -c "conan --version"

reportResults
