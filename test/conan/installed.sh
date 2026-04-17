#!/bin/bash

# Test scenario: specific_version
# Tests installing a specific Conan 1.x version

set -e

source dev-container-features-test-lib

check "conan already installed" command -v conan
check "conan version is 1.62.0" bash -c "conan --version | grep '1.62.0'"

reportResults
