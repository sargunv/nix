# System Configuration

NixOS and nix-darwin configurations managed with flakes.

## Day-to-day usage

```sh
mise run apply    # rebuild and switch
mise run check    # validate flake without building
mise run update   # update flake.lock
```

## Bootstrapping a NixOS host

1. Install NixOS (secure boot off).

2. Clone and enter the repo:

   ```sh
   nix-shell -p git --run "git clone https://github.com/sargunv/nix ~/Code/nix"
   cd ~/Code/nix
   nix develop
   ```

3. Create secure boot keys:

   ```sh
   nix-shell -p sbctl --run "sudo sbctl create-keys"
   ```

4. Set up host config:

   ```sh
   mkdir -p hosts/new-hostname
   cp /etc/nixos/hardware-configuration.nix hosts/new-hostname/
   ```

   Create `hosts/new-hostname/default.nix` and add a `nixosConfigurations` entry in `flake.nix`.

5. Register this host's SSH key:

   ```sh
   mise run keys:init-host
   ```

6. Build and switch:

   ```sh
   sudo nixos-rebuild switch --flake .#new-hostname
   ```

7. If a YubiKey is registered, install its SSH key handle:

   ```sh
   load-yubikey
   ```

8. Reboot, enable secure boot in BIOS, then enroll keys:

   ```sh
   sudo sbctl enroll-keys --microsoft
   ```

## Bootstrapping a macOS host

1. Install [Lix](https://lix.systems/install/#on-any-other-linuxmacos-system).

2. Clone and enter the repo:

   ```sh
   git clone https://github.com/sargunv/nix ~/Code/nix
   cd ~/Code/nix
   nix develop
   ```

3. Create `hosts/Your-Hostname/default.nix` and add a `darwinConfigurations` entry in `flake.nix`.

4. Register this host's SSH key:

   ```sh
   mise run keys:init-host
   ```

5. First build:

   ```sh
   sudo nix run nix-darwin -- switch --flake .
   ```

6. If a YubiKey is registered, install its SSH key handle:

   ```sh
   load-yubikey
   ```

7. Subsequent rebuilds:

   ```sh
   mise run apply
   ```

   On macOS this builds as your user, then updates the system profile and
   activates it as root. That avoids root-owned git objects while still making
   the new generation persistent.

## Key management

SSH public keys are stored in `keys/` and distributed via nix (authorized_keys on NixOS).

```sh
mise run keys:init-host       # ensure hardware-backed SSH key, register it
mise run keys:init-yubikey    # register a YubiKey's SSH key
load-yubikey                  # download YubiKey SSH handle to ~/.ssh/ (on PATH via nix)
```

### Decommissioning a host

Remove its key from `keys/hosts/` and its config from `hosts/` and `flake.nix`.

### Removing a YubiKey

Delete `keys/yubikeys/<name>/`.
