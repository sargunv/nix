{ pkgs, ... }:

{
  home.packages = [ pkgs.ugrep ];

  programs.zsh.shellAliases = {
    # ugrep shortcuts
    uq = "ug -Q";
    uz = "ug -z";
    ux = "ug -U --hexdump";
    ugit = "ug -R --ignore-files";
    # replace grep variants
    grep = "ug -G";
    egrep = "ug -E";
    fgrep = "ug -F";
    zgrep = "ug -zG";
    zegrep = "ug -zE";
    zfgrep = "ug -zF";
    # utilities
    xdump = "ugrep -X \"\"";
    zmore = "ugrep+ -z -I -+ --pager \"\"";
  };
}
