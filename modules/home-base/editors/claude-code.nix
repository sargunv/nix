# Claude Code CLI configuration.
{
  thaw.paths = [ ".claude/settings.json" ];

  home.shellAliases.clauded = "claude --dangerously-skip-permissions";

  programs.claude-code = {
    enable = true;
    settings = {
      voiceEnabled = true;
      skipDangerousModePermissionPrompt = true;
      enabledPlugins = {
        "feature-dev@claude-plugins-official" = true;
        "frontend-design@claude-plugins-official" = true;
        "code-review@claude-plugins-official" = true;
        "code-simplifier@claude-plugins-official" = true;
        "ralph-loop@claude-plugins-official" = true;
        "commit-commands@claude-plugins-official" = true;
        "gopls-lsp@claude-plugins-official" = true;
        "rust-analyzer-lsp@claude-plugins-official" = true;
        "typescript-lsp@claude-plugins-official" = true;
        "clangd-lsp@claude-plugins-official" = true;
      };
      showThinkingSummaries = true;
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
}
