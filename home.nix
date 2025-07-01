{ config, pkgs, ... }:

{
  imports = [
    ./home/hyprpanel.nix
  ];


  home.username = "raistah";
  home.homeDirectory = "/home/raistah";

  home.packages = with pkgs; [
   neofetch
   btop
  ];

  home.stateVersion = "25.05";
}
