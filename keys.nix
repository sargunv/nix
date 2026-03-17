# Public key registry for all hosts and YubiKeys.
# Key files are managed by: mise run keys:*
let
  trim = s: builtins.replaceStrings [ "\n" "\r" ] [ "" "" ] s;
  readKeys =
    dir:
    if builtins.pathExists dir then
      builtins.mapAttrs (name: _: trim (builtins.readFile (dir + "/${name}"))) (builtins.readDir dir)
    else
      { };
  readSubdirFile =
    dir: filename:
    let
      entries = if builtins.pathExists dir then builtins.readDir dir else { };
      dirs = builtins.filter
        (name: entries.${name} == "directory" && builtins.pathExists (dir + "/${name}/${filename}"))
        (builtins.attrNames entries);
    in
    builtins.listToAttrs (map (name: {
      inherit name;
      value = trim (builtins.readFile (dir + "/${name}/${filename}"));
    }) dirs);
in
{
  # Per-host SSH public keys (hardware-backed)
  hostSshKeys = readKeys ./keys/hosts;

  # YubiKey SSH public keys
  yubikeySshKeys = readSubdirFile ./keys/yubikeys "public-key";
}
