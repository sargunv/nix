# Git and GitHub CLI configuration.
{ lib, gitignore, ... }:

let
  readIgnoreFile = path:
    builtins.filter
      (line: line != "" && !lib.hasPrefix "#" line)
      (lib.splitString "\n" (builtins.readFile path));
in
{
  programs.git = {
    enable = true;
    ignores =
      readIgnoreFile "${gitignore}/Global/Linux.gitignore"
      ++ readIgnoreFile "${gitignore}/Global/macOS.gitignore"
      ++ readIgnoreFile "${gitignore}/Global/mise.gitignore";
    settings = {
      user = {
        name = "Sargun Vohra";
        email = "sargunv@users.noreply.github.com";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
  };
}
