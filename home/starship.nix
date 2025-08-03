{ inputs, ... }:
{
  programs.starship = {
    enable = true;

    enableFishIntegration = true;
    enableTransience = true;
  };

  home.file = {
    ".config/starship.toml" = {
      source = ./dotfiles/starship-gruvbox-rainbow.toml;
    };
  };
}
