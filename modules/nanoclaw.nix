# NanoClaw AI agent: shared options with platform-specific service wiring.
# Enable per-host with `local.nanoclaw.enable = true`.
#
# Service definitions live in:
#   modules/nixos-base/nanoclaw.nix  (systemd)
#   modules/darwin/nanoclaw.nix      (launchd)
{
  lib,
  ...
}:
{
  options.local.nanoclaw = {
    enable = lib.mkEnableOption "NanoClaw AI agent";
  };
}
