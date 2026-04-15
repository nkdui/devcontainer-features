#!/bin/bash

# Test scenario: fedora
# Tests Conan installation on Fedora latest

set -e

source dev-container-features-test-lib

check "conan installed on fedora" command -v conan
check "conan version works" bash -c "conan --version"

reportResults
