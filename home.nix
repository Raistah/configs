{ config, pkgs, ... }:

{
  home.username = "raistah";
  home.homeDirectory = "/home/raistah";

  home.packages = with pkgs; [
   neofetch
   btop
  ];

  home.stateVersion = "24.11";
}
