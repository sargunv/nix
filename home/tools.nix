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

  # Editor config
  editorconfig = {
    enable = true;
    settings."*" = {
      charset = "utf-8";
      end_of_line = "lf";
      insert_final_newline = true;
      trim_trailing_whitespace = true;
    };
  };

  # System info
  programs.fastfetch = {
    enable = true;
  };
}
