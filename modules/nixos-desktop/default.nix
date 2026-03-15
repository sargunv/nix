# Desktop-specific NixOS modules: boot extras, DE, and theming.
{
  imports = [
    ../stylix.nix
    ./boot.nix
    ./desktop.nix
    ./stylix.nix
  ];
}
