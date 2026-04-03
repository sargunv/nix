{
  programs.starship = {
    enable = true;
    presets = [ "pure-preset" ];
    settings = {
      # Extend the second line with direnv and mise status
      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$direnv$mise$character";

      time = {
        disabled = false;
        style = "dimmed";
      };
      directory.truncate_to_repo = false;
      right_format = "$shell$time";

      direnv = {
        disabled = false;
        format = "[$loaded]($style) ";
        style = "bright-black";
        loaded_msg = "direnv";
        unloaded_msg = "";
        allowed_msg = "";
        not_allowed_msg = "";
        denied_msg = "";
      };

      shell = {
        disabled = false;
        format = "[$indicator]($style) ";
        style = "bright-black";
      };

      hostname = {
        ssh_symbol = " ";
      };

      mise = {
        disabled = false;
        format = "[$symbol]($style) ";
        style = "bright-black";
        symbol = "mise";
      };
    };
  };
}
