# NixOS configuration for optiplex.
{ pkgs, ... }:
{
  imports = [
    ../../modules/nixos-base
    ./hardware-configuration.nix
  ];

  networking.hostName = "optiplex";

  # Coder is published through Caddy on another LAN host as:
  #   https://coder.home.sargunv.dev -> http://optiplex:3000
  # Authelia OIDC should use this redirect URI:
  #   https://coder.home.sargunv.dev/api/v2/users/oidc/callback
  # Coder reads OIDC secrets from /var/lib/coder/oidc.env; create it with:
  #   mise run coder-oidc-env
  # The env file must contain:
  #   CODER_OIDC_ISSUER_URL=https://auth.home.sargunv.dev
  #   CODER_OIDC_CLIENT_ID=coder
  #   CODER_OIDC_CLIENT_SECRET=...
  networking.firewall.allowedTCPPorts = [ 3000 ];
  services.coder = {
    enable = true;
    # nixpkgs' Coder package can lag upstream; pin the current upstream binary here.
    package = pkgs.coder.overrideAttrs (_old: rec {
      version = "2.34.0-rc.0";
      src = pkgs.fetchurl {
        url = "https://github.com/coder/coder/releases/download/v${version}/coder_${version}_linux_amd64.tar.gz";
        hash = "sha256-xAsy3ocdspSiJkdSBuHMva296hCCbbIL32bwvm2foR8=";
      };
    });
    listenAddress = "0.0.0.0:3000";
    accessUrl = "https://coder.home.sargunv.dev";
    environment = {
      file = "/var/lib/coder/oidc.env";
      extra = {
        CODER_DISABLE_PASSWORD_AUTH = "true";
        CODER_EXPERIMENTS = "agents";
        CODER_OIDC_SCOPES = "openid,profile,email,offline_access";
        CODER_OIDC_SIGN_IN_TEXT = "Sign in with Authelia";
      };
    };
  };
  users.users.coder.extraGroups = [ "docker" ];

  local.boot.secureBoot = false;
  local.nfs.backups.enable = true;

  local.backups = {
    enable = true;
    paths = [
      "/var/lib/crafty"
    ];
  };

  local.crafty = {
    enable = true;
    minecraftPorts = [
      25565
      25566
      25567
      25568
      25569
    ];
    sidecarPorts = [
      25564
      25563
      25562
      25561
      25560
    ];
  };

  system.stateVersion = "25.11";
}
