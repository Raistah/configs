{ config, pkgs, ... }:

{
  imports = [
    ./home/hypridle.nix
    ./home/hyprlock.nix
    ./home/hyprpanel.nix
    ./home/hyprpaper.nix
    ./home/cliphist.nix
    ./home/vim.nix
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
