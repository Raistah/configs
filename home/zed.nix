{ inputs, ... }:
{
  programs.zed-editor = {
    enable = true;
  };

  home.file = {
    ".config/zed/keymap.json" = {
      source = ./dotfiles/zed-keymap.jsonc;
    };
    ".config/zed/settings.json" = {
      source = ./dotfiles/zed-settings.jsonc;
    };
  };
}
