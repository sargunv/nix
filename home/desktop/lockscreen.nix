# Hyprlock (lock screen) and Hypridle (idle management).
{ config, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        blur_passes = 3;
        blur_size = 6;
      };
      input-field = {
        size = "250, 60";
        position = "0, -200";
        halign = "center";
        valign = "center";
        placeholder_text = "";
      };
      label = [
        {
          text = ''cmd[update:1000] date +"%H"'';
          font_size = 150;
          font_family = config.stylix.fonts.sansSerif.name;
          color = "rgba(${config.lib.stylix.colors.base09}99)";
          position = "0, 250";
          halign = "center";
          valign = "center";
        }
        {
          text = ''cmd[update:1000] date +"%M"'';
          font_size = 150;
          font_family = config.stylix.fonts.sansSerif.name;
          color = "rgba(${config.lib.stylix.colors.base05}99)";
          position = "0, 50";
          halign = "center";
          valign = "center";
        }
        {
          text = ''cmd[update:60000] date +"%A, %d %B"'';
          font_size = 24;
          font_family = config.stylix.fonts.sansSerif.name;
          color = "rgb(${config.lib.stylix.colors.base04})";
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
