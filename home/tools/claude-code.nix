# Claude Code CLI configuration.
{
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
}
