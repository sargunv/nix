# CLI tools.
{ pkgs, ... }:
{
  home.packages = [ pkgs.ugrep pkgs.proton-pass-cli pkgs.nixfmt ];

  programs.bat.enable = true;
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
      provider = {
        local = {
          npm = "@ai-sdk/openai-compatible";
          name = "Local LLM";
          options.baseURL = "http://localhost:8000/v1";
          models = {
            "qwen3.5-35b-a3b" = {
              name = "Qwen 3.5 35B-A3B";
            };
            "qwen3.5-122b-a10b" = {
              name = "Qwen 3.5 122B-A10B";
            };
          };
        };
      };
      model = "local/qwen3.5-122b-a10b";
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
