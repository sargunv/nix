# CLI tools and language servers.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editors
    helix # terminal modal editor
    claude-code # AI coding assistant (Anthropic)
    opencode # AI coding assistant (open-source, multi-provider)

    # Search and navigation
    ripgrep # fast regex search (rg)
    fd # fast file finder


    # Dev tools
    mise # polyglot runtime manager
    github-cli # GitHub from the terminal (gh)
    fastfetch # system info display
  ];
}
