# LocalSend - cross-platform file sharing.
{ pkgs, lib, osConfig, ... }:

let
  alias = osConfig.networking.hostName;
  prefsDir = "org.localsend.localsend_app";
  prefsFile = "${prefsDir}/shared_preferences.json";
in
{
  home.packages = [ pkgs.localsend ];

  xdg.configFile."autostart/localsend_app.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=LocalSend
    Exec=localsend_app --hidden
    StartupNotify=false
    Terminal=false
  '';

  home.activation.localsend-alias =
    lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
        prefs="$HOME/.local/share/${prefsFile}"
        mkdir -p "$HOME/.local/share/${prefsDir}"
        if [ -f "$prefs" ]; then
          ${lib.getExe pkgs.jq} --arg alias ${lib.escapeShellArg alias} \
            '.["flutter.ls_alias"] = $alias' "$prefs" > "$prefs.tmp" \
            && mv "$prefs.tmp" "$prefs"
        else
          echo ${lib.escapeShellArg (builtins.toJSON { "flutter.ls_alias" = alias; })} > "$prefs"
        fi
      '';
}
