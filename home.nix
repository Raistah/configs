{ config, pkgs, ... }:

{
  imports = [
    ./home/hyprpanel.nix
    ./home/tofi.nix
    ./home/fish.nix
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
      source = ./home/dotfiles/config.toml;
      recursive = true;
    };
  };

  home.stateVersion = "25.05";
}
