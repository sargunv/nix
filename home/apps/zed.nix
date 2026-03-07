# Zed editor.
{
  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" "toml" "dockerfile" ];
    userSettings = {
      vim_mode = true;
      buffer_font_family = "MonaspiceAr Nerd Font";
      terminal.font_family = "MonaspiceAr Nerd Font";
    };
  };
}
