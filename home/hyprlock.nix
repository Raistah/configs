{ inputs, ... }:
{
  programs.hyprlock = {
    enable = true;
  };

  home.file = {
    ".config/hypr/hyprlock.conf" = {
      source = ./dotfiles/hyprlock.conf;
    };
  };
}
