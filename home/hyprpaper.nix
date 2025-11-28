{ inputs, config, ... }:
{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [ "/etc/nixos/wallpapers/aishot-2498.jpg" ];

      wallpaper = [
        "DP-1, /etc/nixos/wallpapers/aishot-2498.jpg"
      ];
    };
  };
}
