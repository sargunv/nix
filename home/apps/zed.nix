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
      edit_predictions = {
        provider = "open_ai_compatible_api";
        open_ai_compatible_api = {
          api_url = "http://localhost:8000/v1/completions";
          model = "qwen2.5-coder-1.5b";
          prompt_format = "qwen";
          max_output_tokens = 64;
        };
      };
    };
  };
}
