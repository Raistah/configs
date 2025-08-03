{ inputs, ... }:
{
  programs.waybar = {
    enable = true;
  };

  home.file = {
    ".config/waybar/style.css" = {
      source = ./dotfiles/waybar.css;
      recursive = true;
    };
    ".config/waybar/config.jsonc" = {
      source = ./dotfiles/waybar.jsonc;
      recursive = true;
    };
  };
}
