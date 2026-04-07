# Claude Code CLI configuration.
{
  thaw.paths = [ ".claude/settings.json" ];

  home.shellAliases.clauded = "claude --dangerously-skip-permissions";

  programs.claude-code = {
    enable = true;
    settings = {
      voiceEnabled = true;
      skipDangerousModePermissionPrompt = true;
      extraKnownMarketplaces = {
        sargunv-plugins = {
          source = {
            source = "github";
            repo = "sargunv/claude-plugins";
          };
        };
      };
      enabledPlugins = {
        "craft@sargunv-plugins" = true;
        "frontend-design@claude-plugins-official" = true;
        "skill-creator@claude-plugins-official" = true;
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
