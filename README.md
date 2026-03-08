# my nix system

supports:

- NixOS (host = `framework-desktop`)
- macOS (TODO)

new NixOS setup:

- Install NixOS with secure boot disabled
- Copy the generated /etc/nixos/hardware-configuration.nix to the appropriate host in this project
- `nix-shell -p sbctl`
- `sudo sbctl create-keys`
- `sudo nixos-rebuild switch --flake .#HOST`
  - replace `HOST` with the supported host name
- `sudo sbctl enroll-keys --microsoft`
- Reboot and enable secure boot

new macOS setup:

- TODO