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
   neofetch
   btop
  ];

  home.file = {
    ".config/hypr/hyprland.conf" = {
      source = ./home/dotfiles/hyprland.conf;
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
  };

  home.stateVersion = "25.05";
}
