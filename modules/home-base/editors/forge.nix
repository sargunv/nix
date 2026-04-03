# Forge CLI coding tool with zsh shell integration.
{ lib, pkgs, ... }:

let
  forge = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "forge";
    version = "2.4.1";
    src = pkgs.fetchurl {
      url = "https://github.com/antinomyhq/forge/releases/download/v${version}/forge-${
        if pkgs.stdenv.hostPlatform.isDarwin then
          if pkgs.stdenv.hostPlatform.isAarch64 then
            "aarch64-apple-darwin"
          else
            "x86_64-apple-darwin"
        else if pkgs.stdenv.hostPlatform.isAarch64 then
          "aarch64-unknown-linux-gnu"
        else
          "x86_64-unknown-linux-gnu"
      }";
      hash =
        if pkgs.stdenv.hostPlatform.isDarwin && pkgs.stdenv.hostPlatform.isAarch64 then
          "sha256-E7/tjwGKwd06x9vy0bRbMjz9I596/eufmDWOqbMwHAI="
        else if pkgs.stdenv.hostPlatform.isDarwin then
          "sha256-gJnPAz3JJ4FdBIKbwrxr/nMkeBJ8SFaN0sqHMYw9DM0="
        else if pkgs.stdenv.hostPlatform.isAarch64 then
          "sha256-mXrzSLGmwzdEHi3J3+uyZuFfli8iGNLk54tKLto1v1E="
        else
          "sha256-PZUZrjhHtgLoN127iYsbLceSO75DPWjnBRyiNiIFPCw=";
    };
    nativeBuildInputs = lib.optionals pkgs.stdenv.isLinux [
      pkgs.autoPatchelfHook
    ];
    buildInputs = lib.optionals pkgs.stdenv.isLinux [
      pkgs.stdenv.cc.cc.lib
      pkgs.openssl
    ];
    dontUnpack = true;
    installPhase = ''
      install -Dm755 $src $out/bin/forge
    '';
  };
in
{
  home.packages = [ forge ];

  programs.zsh.initContent = lib.mkOrder 1500 ''
    # Forge shell integration (after starship prompt init)
    if [[ -z "$_FORGE_PLUGIN_LOADED" ]]; then
      eval "$(${forge}/bin/forge zsh plugin)"
    fi
    if [[ -z "$_FORGE_THEME_LOADED" ]]; then
      eval "$(${forge}/bin/forge zsh theme)"
    fi
  '';
}
