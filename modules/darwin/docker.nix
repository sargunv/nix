# Docker via Colima: lightweight container runtime for macOS.
{ pkgs, config, ... }:
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
        PATH = "${pkgs.colima}/bin:${pkgs.lima}/bin:${pkgs.docker-client}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = true;
      };
      WorkingDirectory = config.users.users.sargunv.home;
    };
  };
}
