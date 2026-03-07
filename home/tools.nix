# CLI tools and language servers.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editors
    helix # terminal modal editor
    claude-code # AI coding assistant

    # Search and navigation
    ripgrep # fast regex search (rg)
    fd # fast file finder
    eza # modern ls replacement

    # Dev tools
    mise # polyglot runtime manager
    github-cli # GitHub from the terminal (gh)
    fastfetch # system info display

    # Nix language servers
    nil # nix LSP
    nixd # nix LSP (alternative)
  ];
}
