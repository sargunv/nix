# Shell configuration: zsh and starship prompt.
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  programs.starship = {
    enable = true;
    settings = { };
  };
}
