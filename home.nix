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
    ./home/waybar.nix
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
    ".icons/Nordzy-hyprcursors" = {
      source = ./home/icons/Nordzy-hyprcursors;
      recursive = true;
    };

    "scripts/screenshots_menu.sh" = {
      source = ./home/scripts/screenshots_menu.sh;
      recursive = true;
      executable = true;
    };
  };

  home.stateVersion = "25.05";
}
