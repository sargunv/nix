# Voxtype - push-to-talk voice dictation with local Whisper.
{ pkgs, ... }:

let
  whisper-model = pkgs.fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin";
    hash = "sha256-H8cPd0046xaZk6w5Huo1fvR8iHV+9y7llDh5t+jivGk=";
  };
in
{
  home.packages = with pkgs; [
    voxtype-vulkan
    dotool
    wtype
  ];

  xdg.dataFile."voxtype/models/ggml-large-v3-turbo.bin".source = whisper-model;

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
    model = "large-v3-turbo"
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
      ExecStart = "${pkgs.voxtype-vulkan}/bin/voxtype daemon";
      Restart = "on-failure";
      RestartSec = 5;
      Environment = "XDG_RUNTIME_DIR=%t";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
