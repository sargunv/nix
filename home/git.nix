# Git and GitHub CLI configuration.
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Sargun Vohra";
        email = "sargunv@users.noreply.github.com";
      };
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
  };
}
