{
  programs.starship = {
    enable = true;
    presets = [ "pure-preset" ];
    settings = {
      format = "$username$hostname$directory$git_branch$git_state$git_metrics$git_status$cmd_duration$line_break$python$character";

      time = {
        disabled = false;
        style = "dimmed";
      };
      directory.truncate_to_repo = false;
      git_status.ignore_submodules = true;
      git_metrics = {
        disabled = false;
        ignore_submodules = true;
        format = "([ +$added]($added_style))([ -$deleted]($deleted_style)) ";
        added_style = "green";
        deleted_style = "red";
      };
      right_format = "$shell$time";

      shell = {
        disabled = false;
        format = "[$indicator]($style) ";
        style = "bright-black";
      };

      hostname = {
        ssh_symbol = " ";
      };

    };
  };
}
