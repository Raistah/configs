# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [ "amdgpu.runpm=0" ];

  boot.supportedFilesystems = {
    ext4 = true;
    vfat = true;
    exfat = true;
  };

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking = {
    networkmanager = {
    	enable = true;
    	wifi = {
     		backend = "iwd";
      	powersave = false;
     	};
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --remember --remember-user-session --time --sessions /etc/nixos/desktop";
          user = "raistah";
        };
      };
    };

    # Configure keymap in X11
    xserver = {
      xkb = {
        layout = "us, ua";
        variant = "";
      };
      videoDrivers = ["amdgpu"];
    };

    gvfs.enable = true;
    udisks2.enable = true;

    udev = {
      enable = true;

      # 1 - usb switch, 2 - keyboard, 3 - mouse
      extraRules = ''
        SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="05e3", ATTRS{idProduct}=="0625", ATTR{../power/wakeup}="enabled"
        SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="3151", ATTRS{idProduct}=="502e", ATTR{../power/wakeup}="enabled"
        SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="1d57", ATTRS{idProduct}=="fa60", ATTR{../power/wakeup}="enabled"
      '';
    };

    mysql = {
	    package = pkgs.mariadb;
	    enable = true;
	    ensureUsers = [{
        name = "root";
        ensurePermissions = {
    	    "myDatabase.*" = "ALL PRIVILEGES";
        };
	    }];
    };
  };

  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.raistah = {
    isNormalUser = true;
    description = "Raistah";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "beekeeper-studio-5.3.4"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
		vtsls
    amdgpu_top
    beekeeper-studio
    bluez
    bluetui
    ddcutil
    exfatprogs
    fd
    ffmpeg
    firefox
    fzf
    git
    git-filter-repo
    gitui
    gnutar
    hyprcursor
    hyprpicker
    hyprshot
    imagemagick
    kdePackages.dolphin
    killall
    lact
    libnotify
    mangohud
    mesa
    ngrok
    nil
    nixd
    nodejs_24
    p7zip
    package-version-server
    pavucontrol
    protonplus
    qbittorrent
    resvg
    rio
    ripgrep
    sqlite
    unzip
    vlc
    wget
    wl-clipboard
    yazi
    zoxide
  ];

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "vim";
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
    uwsm = {
      enable = true;
      waylandCompositors = {
        hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/Hyprland";
        };
      };
    };
    ssh.startAgent = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };


  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
