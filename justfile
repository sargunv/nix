# System management tasks

rebuild := if os() == "macos" { "darwin-rebuild" } else { "nixos-rebuild" }

# Choose a recipe to run
_default:
    @just --choose

# Build the system configuration
build:
    {{ rebuild }} build --flake . -vL

# Activate the built configuration
apply: build
    sudo ./result/activate

# Validate flake without building
check:
    nix flake check --no-build

# Update flake.lock
update:
    nix flake update

# View the auto-upgrade log (macOS only)
[macos]
upgrade-log:
    tail -f /var/log/darwin-auto-upgrade.log

# Trigger an auto-upgrade now and follow the log (macOS only)
[macos]
upgrade-now: && upgrade-log
    sudo launchctl kickstart system/org.nixos.darwin-auto-upgrade
