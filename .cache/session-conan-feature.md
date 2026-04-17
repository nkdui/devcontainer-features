# Session Cache - Conan Feature Update

## Project
Dev Container Features repo at `/root/projs/devcontainer-features`

## Task
Modify `conan` feature to only support Conan 1.x (user plans preconfiguration options incompatible with Conan 2)

## Changes Made

### src/conan/devcontainer-feature.json
- Name: "Conan Package Manager (1.x)"
- Version bumped to 1.1.0
- Kept `conanVersion` option but restricted to 1.x only
- Documentation URL: https://docs.conan.io/en/1.x/

### src/conan/install.sh
- Refactored into clean functions: `validate_version()`, `check_existing_conan()`, `detect_distribution()`, `install_python()`, `install_conan()`, `setup_conan_home()`
- Validates requested version is 1.x (rejects 2.x)
- "latest" installs `conan<2` (newest 1.x)
- Uses `.conan` directory (Conan 1.x format) not `.conan2`

### test/conan/
- `scenarios.json`: kept `specific_version` with `"conanVersion": "1.66.0"`
- `specific_version.sh`: checks for 1.66.0
- `test.sh`: checks for 1.x version format

## Key Decisions
- Keep version parameter, restrict to 1.x (not remove it)
- Write test values hardcoded per standard devcontainer feature practice

## Files Modified
- src/conan/devcontainer-feature.json
- src/conan/install.sh
- test/conan/scenarios.json
- test/conan/specific_version.sh
- test/conan/test.sh