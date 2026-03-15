# Auto-upgrade from GitHub, equivalent to NixOS's system.autoUpgrade.
{ config, pkgs, ... }:
let
  flake = "github:sargunv/nix";
  hostname = config.networking.hostName;
  upgrade-script = pkgs.writeShellScript "darwin-auto-upgrade" ''
    set -euo pipefail
    export PATH=/run/current-system/sw/bin:$PATH
    echo "$(date): starting auto-upgrade from ${flake}"
    darwin-rebuild switch --flake "${flake}#${hostname}" 2>&1
    echo "$(date): auto-upgrade complete"
  '';
in
{
  launchd.daemons.darwin-auto-upgrade = {
    serviceConfig = {
      ProgramArguments = [ "${upgrade-script}" ];
      StartCalendarInterval = [{ Hour = 4; Minute = 0; }];
      StandardOutPath = "/var/log/darwin-auto-upgrade.log";
      StandardErrorPath = "/var/log/darwin-auto-upgrade.log";
    };
  };
}
