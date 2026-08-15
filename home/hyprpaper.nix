{ inputs, config, ... }:
{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;

      preload = [ "/etc/nixos/wallpapers/aishot-2498.jpg" ];

      wallpaper = [
        {
          monitor = "DP-1";
          path = "/etc/nixos/wallpapers/aishot-2498.jpg";
          fit_mode = "cover";
        }
      ];
    };
  };
}
