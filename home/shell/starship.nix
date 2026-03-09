{
  programs.starship = {
    enable = true;
    presets = [ "pure-preset" ];
    settings = {
      time = {
        disabled = false;
        style = "dimmed";
      };
      directory.truncate_to_repo = false;
      right_format = "$time";
    };
  };
}
