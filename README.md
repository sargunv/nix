# System Configuration

NixOS and nix-darwin configurations managed with flakes.

## Bootstrapping a NixOS host

1. Install NixOS with the graphical or minimal installer (secure boot off).

2. Clone the repo:

   ```sh
   nix-shell -p git --run "git clone https://github.com/sargunv/nix ~/Code/nix"
   cd ~/Code/nix
   ```

3. Create secure boot keys for Lanzaboote:

   ```sh
   nix-shell -p sbctl --run "sudo sbctl create-keys"
   ```

4. Create a new host directory:

   ```sh
   mkdir -p hosts/new-hostname
   cp /etc/nixos/hardware-configuration.nix hosts/new-hostname/
   ```

5. Create `hosts/new-hostname/default.nix` with host-specific settings (see
   `hosts/framework-desktop/default.nix` for reference).

6. Add a `nixosConfigurations.new-hostname` entry in `flake.nix`.

7. Build and switch:

   ```sh
   sudo nixos-rebuild switch --flake .#new-hostname
   ```

8. Reboot, then enroll secure boot keys and enable secure boot in BIOS:

   ```sh
   sudo sbctl enroll-keys --microsoft
   ```

## Bootstrapping a macOS host

1. Install [Lix](https://lix.systems/install/#on-any-other-linuxmacos-system).

2. Clone the repo:

   ```sh
   git clone https://github.com/sargunv/nix ~/Code/nix
   cd ~/Code/nix
   ```

3. Create `hosts/Your-Hostname/default.nix` with host-specific settings (see
   `hosts/Sarguns-MacBook-Pro/default.nix` for reference).

4. Add a `darwinConfigurations.Your-Hostname` entry in `flake.nix`.

5. First build (nix-darwin isn't installed yet):

   ```sh
   sudo nix run nix-darwin -- switch --flake .
   ```

6. Subsequent rebuilds:

   ```sh
   just apply
   ```

## Day-to-day usage

```sh
just apply    # rebuild and switch
just check    # validate flake without building
just update   # update flake.lock
```
