# Voxtype - push-to-talk voice dictation (Linux only).
# Uses the system-level whisper-server (see hosts/*/inference.nix).
{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  home.packages = with pkgs; [
    voxtype
    dotool
    wtype
  ];

  xdg.configFile."voxtype/config.toml".text = ''
    [hotkey]
    # Disabled: using KDE global shortcut instead to avoid key repeat leak.
    # On Hyprland/Sway, can re-enable with key = "F13" and use compositor bindings.
    enabled = false

    [audio]
    device = "default"
    sample_rate = 16000
    max_duration_secs = 60

    [audio.feedback]
    enabled = true

    [whisper]
    mode = "remote"
    remote_endpoint = "http://127.0.0.1:8090"
    language = "en"

    [output]
    mode = "type"
    fallback_to_clipboard = true
    # dotool first: Plasma workaround (wtype unsupported on KDE Wayland).
    # On Hyprland/Sway, change to ["wtype", "clipboard"].
    driver_order = ["dotool", "wtype", "clipboard"]
    append_text = " "

    [output.notification]
    on_recording_start = false
    on_recording_stop = false
    on_transcription = true
  '';

  systemd.user.services.voxtype = {
    Unit = {
      Description = "Voxtype voice dictation daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.voxtype}/bin/voxtype daemon";
      Restart = "on-failure";
      RestartSec = 5;
      Environment = "XDG_RUNTIME_DIR=%t";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
