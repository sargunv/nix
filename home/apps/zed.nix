# Zed editor.
{
  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" "toml" "dockerfile" "gruvbox" "git-firefly" "just" ];
    userSettings = {
      theme = "Gruvbox Dark Hard";
load_direnv = "shell_hook";
      buffer_font_family = "MonaspiceAr Nerd Font";
      terminal.font_family = "MonaspiceAr Nerd Font";
      edit_predictions.provider = "sweep";
    };
  };
}
