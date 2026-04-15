#!/bin/bash

# Test scenario: debian
# Tests Conan installation on Debian latest

set -e

source dev-container-features-test-lib

check "conan installed on debian" command -v conan
check "conan version works" bash -c "conan --version"

reportResults
