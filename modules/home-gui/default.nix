# GUI applications and editors, cross-platform (Linux desktop + macOS).
{
  imports = [
    ./packages.nix
    ./localsend.nix
    ./editors/vscodium.nix
    ./editors/zed.nix
    ./editors/t3code.nix
  ];

  # JetBrains Toolbox scripts
  home.sessionPath = [ "$HOME/.local/share/JetBrains/Toolbox/scripts" ];
}
