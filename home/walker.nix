{ inputs, ... }:
{
  imports = [inputs.walker.homeManagerModules.default];

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      theme = "default"; # nixos to use my
      terminal = "rio";
      list = {
        height = 200;
      };
      app_launch_prefix = "uwsm app -- ";

      search.placeholder = "Search...";

      ui.fullscreen = true;

      websearch.prefix = "?";

      switcher.prefix = "/";
    };

    theme.style = ''
      * {
        color: #fcba03;
      }
    '';
  };
}
