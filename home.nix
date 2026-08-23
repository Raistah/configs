{ config, pkgs, lib, ... }:

let
  scriptsSrcDir = ./home/scripts;
  scriptsFiles = builtins.attrNames (builtins.readDir scriptsSrcDir);
  scripts = builtins.listToAttrs (map (filename: {
    name = "scripts/${filename}";
    value = {
      source = "${scriptsSrcDir}/${filename}";
      executable = true;
    };
  }) scriptsFiles);
in
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

    # eww
    ".config/eww" = {
      source = ./home/eww;
      recursive = true;
    };
    ".config/eww/eww.yuck" = {
      source = ./home/eww/eww.yuck;
      recursive = true;
    };
  } // scripts;

  home.stateVersion = "25.05";
}
