#!/bin/bash

# Test scenario: archlinux
# Tests Conan installation on Arch Linux latest

set -e

source dev-container-features-test-lib

check "conan installed on archlinux" command -v conan
check "conan version works" bash -c "conan --version"

reportResults
