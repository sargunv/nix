# Claude Code CLI configuration.
{
  thaw.paths = [ ".claude/settings.json" ];

  home.shellAliases.clauded = "claude --dangerously-skip-permissions";

  programs.claude-code = {
    enable = true;
    settings = {
      skipDangerousModePermissionPrompt = true;
      extraKnownMarketplaces = {
        sargunv-plugins = {
          source = {
            source = "git";
            url = "https://github.com/sargunv/claude-plugins.git";
          };
        };
      };
    };
  };
}
