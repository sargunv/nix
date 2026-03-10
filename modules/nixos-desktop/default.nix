# Desktop-specific NixOS modules: boot extras, DE, and theming.
{
  imports = [
    ./boot.nix
    ./desktop.nix
    ./stylix.nix
  ];
}
