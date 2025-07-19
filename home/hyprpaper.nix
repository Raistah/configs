{ inputs, config, ... }:
{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
      
      preload = [ "${config.home.homeDirectory}/Pictures/aishot-2498.png" ];

      wallpaper = [
        "DP-6,${config.home.homeDirectory}/Pictures/aishot-2498.png"
      ];
    };
  };
}
