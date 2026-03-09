# NixOS configuration for framework-desktop.
{
  imports = [
    ../../modules/desktop.nix
    ../../modules/stylix.nix
    ../../modules/system.nix
    ../../modules/user.nix
    ../../modules/inference.nix
    ./hardware-configuration.nix
    ./boot.nix
  ];

  networking.hostName = "framework-desktop";

  local.inference = {
    sweepNextEdit = true;
    qwenCoder = true;
    qwen35b = true;
    whisper = true;
  };

  system.stateVersion = "25.11";
}
