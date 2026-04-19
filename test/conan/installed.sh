#!/bin/bash

# Test scenario: specific_version
# Tests installing a specific Conan 1.x version

set -e

source dev-container-features-test-lib

check "conan is installed" command -v conan
check "conan --version" bash -c "conan --version"

reportResults
