# NixOS system management tasks

# Reconfigure the machine
apply:
    sudo nixos-rebuild switch --flake .

# Validate flake without building
check:
    nix flake check --no-build

# Update flake.lock
update:
    nix flake update
