# Docker via Colima: lightweight container runtime for macOS.
{ pkgs, config, ... }:
let
  homeDir = "/Users/${config.system.primaryUser}";
in
{
  environment.systemPackages = with pkgs; [
    colima
    docker-client
  ];

  launchd.user.agents.colima = {
    serviceConfig = {
      ProgramArguments = [
        (pkgs.lib.getExe pkgs.colima)
        "start"
        "-f"
      ];
      EnvironmentVariables = {
        HOME = homeDir;
        PATH = "${pkgs.colima}/bin:${pkgs.lima}/bin:${pkgs.docker-client}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        XDG_CACHE_HOME = "${homeDir}/.cache";
        XDG_CONFIG_HOME = "${homeDir}/.config";
        XDG_DATA_HOME = "${homeDir}/.local/share";
      };
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = true;
      };
      WorkingDirectory = homeDir;
    };
  };
}
