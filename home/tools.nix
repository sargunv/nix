# CLI tools.
{
  # Editors
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };

  programs.claude-code = {
    enable = true;
    settings = {
      permissions = {
        allow = [ "Bash" "Edit" "Write" "WebFetch" "Read" ];
      };
    };
  };

  programs.opencode = {
    enable = true;
    settings = {
      permission = "allow";
    };
  };

  # Search and navigation
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
    ];
  };

  programs.fd = {
    enable = true;
  };

  # System info
  programs.fastfetch = {
    enable = true;
  };
}
