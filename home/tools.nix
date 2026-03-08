# CLI tools.
{ pkgs, ... }:
{
  home.packages = [ pkgs.ugrep pkgs.proton-pass-cli pkgs.nixfmt ];
  # Editors
  programs.helix = {
    enable = true;
  };

  programs.claude-code = {
    enable = true;
    settings = {
      permissions = {
        allow = [
          "Bash(*)"
          "Read"
          "Edit"
          "Write"
          "WebFetch"
          "WebSearch"
          "Glob"
          "Grep"
          "Agent"
          "NotebookEdit"
          "mcp__*"
        ];
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

  # Documentation
  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };

  # System info
  programs.fastfetch = {
    enable = true;
  };
}
