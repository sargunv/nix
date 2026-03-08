# Voxtype - push-to-talk voice dictation (Linux only).
# Uses the system-level whisper-server (see hosts/*/inference.nix).
{ pkgs, lib, ... }:

let
  silero-vad = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/whisper-vad/resolve/main/ggml-silero-v6.2.0.bin";
    hash = "sha256-KqJpt4XutTqCmDogUB3ffB2cSOM6tjpBORrGyff7aYc=";
  };
in
lib.mkIf pkgs.stdenv.isLinux {
  home.packages = with pkgs; [
    voxtype
    wtype
  ];

  xdg.dataFile."voxtype/models/ggml-silero-vad.bin".source = silero-vad;

  xdg.configFile."voxtype/config.toml".text = ''
    [hotkey]
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
    language = "auto"

    [output]
    mode = "type"
    fallback_to_clipboard = true
    driver_order = ["wtype"]
    pre_type_delay_ms = 100
    shift_enter_newlines = true
    append_text = " "

    [output.notification]
    on_recording_start = false
    on_recording_stop = false
    on_transcription = true

    [vad]
    enabled = true

    [status]
    icon_theme = "nerd-font"
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
