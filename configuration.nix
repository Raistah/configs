# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
let
	pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true; # Ensures unfree settings carry over if needed
  };
  in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./secrets.nix
    ];

  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [
    "amdgpu"
  ];
  boot.kernelParams = [
    "amdgpu.runpm=0"
    "mem_sleep_default=deep"
    "usbcore.autosuspend=-1"
  ];
  boot.extraModprobeConfig = ''
    options
    usbcore
    use_both_schemes=y
  '';
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

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
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --sessions /etc/nixos/desktop";
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
      # extraRules = ''
      #   SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="05e3", ATTRS{idProduct}=="0625", ATTR{../power/wakeup}="enabled"
      #   SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="3151", ATTRS{idProduct}=="502e", ATTR{../power/wakeup}="enabled"
      #   SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="1d57", ATTRS{idProduct}=="fa60", ATTR{../power/wakeup}="enabled"
      # '';

      packages = [
	     	(pkgs.writeTextFile {
					name = "probe-rs_udev";
					text = builtins.readFile ./udev/69-probe-rs.rules;
					destination = "/etc/udev/rules.d/69-probe-rs.rules";
	      })
      ];
    };

    mysql = {
	    package = pkgs.mariadb;
	    enable = false;
	    ensureUsers = [{
        name = "root";
        ensurePermissions = {
    	    "myDatabase.*" = "ALL PRIVILEGES";
        };
	    }];
    };

    redis.servers."" = {
   		enable = false;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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

  # systemd.services.reset-usb-hub = {
  #   description = "Fast authorization toggle for main USB hub on port 5-1";
  #   wantedBy = [ "multi-user.target" ];
  #   before = [ "display-manager.service" "greetd.service" ];
  #   script = ''
  #     HUB_PORT="5-1"

  #     if [ -d "/sys/bus/usb/devices/$HUB_PORT" ]; then
  #       echo 0 > "/sys/bus/usb/devices/$HUB_PORT/authorized"
  #       sleep 0.1
  #       echo 1 > "/sys/bus/usb/devices/$HUB_PORT/authorized"
  #     fi
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #   };
  # };

  systemd.services.greetd = {
    wants = [ "reset-usb-hub.service" ];
    after = [ "reset-usb-hub.service" ];
    serviceConfig = {
     	Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "tty";

      TTYReset = true;
      TTYHangup = true;
      TTYDisallocate = true;
    };
  };

  users.groups = {
  	plugdev = {};
  };

  users.users.raistah = {
    isNormalUser = true;
    description = "Raistah";
    extraGroups = [ "networkmanager" "wheel" "plugdev" "docker" ];
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
    alacritty
    amdgpu_top
    beekeeper-studio
    bluetui
    bluez
    bmaptool
    bottom
    bruno
    ddcutil
    docker-buildx
    eww
    exfatprogs
    fd
    ffmpeg
    firefox
    fzf
    git-filter-repo
    gitui
    gnumake
    gnutar
    hyprcursor
    hyprpicker
    hyprshot
    imagemagick
    impala
    iptables
    jq
    kdePackages.dolphin
    killall
    lact
    lazydocker
    libnotify
    lsof
    mangohud
    mesa
    ngrok
    nh
    nil
    nixd
    nodejs_24
    openssl
    p7zip
    package-version-server
    pavucontrol
    picocom
    pkg-config
    protonplus
    pulseaudio
    qbittorrent
    qemu
    resvg
    rio
    ripgrep
    rust-script
    signal-desktop
    slurp
    sops
    sqlite
    ssh-to-age
    tmux
    ungoogled-chromium
    unzip
    usbutils
    vlc
    vtsls
    wf-recorder       # The Wayland screen recorder
    wget
    wl-clipboard
    yazi
    zoxide
    # redisinsight
  ];

  virtualisation.docker = {
    enable = true;
  };

  boot.binfmt = {
  	emulatedSystems = [ "aarch64-linux" ];
	  preferStaticEmulators = true;
  };

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";

    # Forces Zed, Rio Terminal, and general toolkits to use the Wayland backend
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    CLUTTER_BACKEND = "wayland";

    # Prevents hardware acceleration layers from falling back to software rendering
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";

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
    nix-ld.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
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
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 80 443 3128 17011 ];
    allowedUDPPorts = [ 80 9993 ];
    trustedInterfaces = [ "docker0" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
