# NixOS configuration for framework-desktop.
{
  imports = [
    ../../nixos/home.nix
    ../../nixos/desktop.nix
    ../../nixos/stylix.nix
    ../../nixos/system.nix
    ../../nixos/user.nix
    ../../nixos/inference.nix
    ./hardware-configuration.nix
    ./boot.nix
  ];

  networking.hostName = "framework-desktop";

  local.desktop = {
    monitors = [
      "desc:ASUSTek COMPUTER INC PG27UCDM TALMAV003641, 3840x2160@120, 0x525, 1.666667, bitdepth, 10"
      "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27U 23323B000942, 3840x2160@120, 2304x0, 1.666667, transform, 1, bitdepth, 10"
    ];
    workspaces = [
      "1, monitor:desc:ASUSTek COMPUTER INC PG27UCDM TALMAV003641, default:true"
      "2, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27U 23323B000942, default:true"
    ];
    xwaylandDpi = 160;
  };

  local.inference = {
    sweepNextEdit = true;
    qwenCoder = true;
    qwen35b = true;
    whisper = true;
  };

  system.stateVersion = "25.11";
}
