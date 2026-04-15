#!/bin/bash

# Test scenario: specific_version
# Tests installing a specific Conan version

set -e

source dev-container-features-test-lib

check "conan installed" command -v conan
check "conan version is 1.66" bash -c "conan --version | grep '1.66'"

reportResults
