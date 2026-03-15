# System management tasks

rebuild := if os() == "macos" { "darwin-rebuild" } else { "nixos-rebuild" }

# Choose a recipe to run
_default:
    @just --choose

# Reconfigure the machine
apply:
    {{ rebuild }} build --flake . -vL
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
