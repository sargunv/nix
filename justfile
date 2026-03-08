# NixOS system management tasks

# Choose a recipe to run
_default:
    @just --choose

# Reconfigure the machine
apply:
    sudo nixos-rebuild switch --flake .

# Validate flake without building
check:
    nix flake check --no-build

# Update flake.lock
update:
    nix flake update
