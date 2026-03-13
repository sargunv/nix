# SwayNC notification center.
{
  services.swaync = {
    enable = true;
    settings = {
      widgets = [ "mpris" "title" "dnd" "notifications" ];
      widget-config.mpris = {
        autohide = true;
        blacklist = [ "playerctld" ];
      };
    };
    style = ''
      /* Soften the borders Stylix applies */
      .notification-content,
      .notification.low,
      .notification.normal,
      .notification.critical,
      .control-center,
      .widget-title > button,
      .widget-dnd > switch,
      .widget-mpris .widget-mpris-player,
      .widget-mpris .widget-mpris-player > box > button,
      .widget-mpris .widget-mpris-player > box > button:hover,
      progress,
      progressbar,
      trough {
        border-color: @base02;
      }

      .notification-content {
        padding: 8px;
      }
    '';
  };
}
