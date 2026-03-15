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
