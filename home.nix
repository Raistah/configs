{ config, pkgs, ... }:

{
  imports = [
    ./home/cliphist.nix
    ./home/dunst.nix
    ./home/fish.nix
    ./home/hypridle.nix
    ./home/hyprlock.nix
    ./home/hyprpaper.nix
    ./home/starship.nix
    ./home/tofi.nix
    ./home/vesktop.nix
    ./home/vim.nix
    ./home/walker.nix
    ./home/zed.nix
  ];


  home.username = "raistah";
  home.homeDirectory = "/home/raistah";

  home.packages = with pkgs; [
   fastfetch
   btop
  ];

  home.file = {
    ".config/hypr/hyprland.lua" = {
      source = ./home/dotfiles/hyprland.lua;
      recursive = true;
    };
    ".config/rio/config.toml" = {
      source = ./home/dotfiles/rio.toml;
      recursive = true;
    };
    ".config/alacritty/alacritty.toml" = {
      source = ./home/dotfiles/alacritty.toml;
      recursive = true;
    };
    ".icons/Nordzy-hyprcursors" = {
      source = ./home/icons/Nordzy-hyprcursors;
      recursive = true;
    };

    "scripts/screenshots_menu.sh" = {
      source = ./home/scripts/screenshots_menu.sh;
      recursive = true;
      executable = true;
    };

    # eww
    ".config/eww/eww.yuck" = {
      source = ./home/eww/eww.yuck;
      recursive = true;
    };
    ".config/eww/eww.scss" = {
      source = ./home/eww/eww.scss;
      recursive = true;
    };
    "scripts/read-volume.sh" = {
      source = ./home/eww/read-volume.sh;
      recursive = true;
      executable = true;
    };
    "scripts/system-monitor.sh" = {
      source = ./home/eww/system-monitor.sh;
      recursive = true;
      executable = true;
    };
    "scripts/watch-active-window.sh" = {
      source = ./home/eww/watch-active-window.sh;
      recursive = true;
      executable = true;
    };
    "scripts/watch-all-workspaces.sh" = {
      source = ./home/eww/watch-all-workspaces.sh;
      recursive = true;
      executable = true;
    };
    "scripts/watch-connected-network.sh" = {
      source = ./home/eww/watch-connected-network.sh;
      recursive = true;
      executable = true;
    };
    "scripts/watch-kb-layout.sh" = {
      source = ./home/eww/watch-kb-layout.sh;
      recursive = true;
      executable = true;
    };
  };

  home.stateVersion = "25.05";
}
