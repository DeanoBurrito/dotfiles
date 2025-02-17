{ config, pkgs, lib, ... }:

#TODO: hyprcursor, hardware graphics accel
#TODO: collisions between clang tools and gcc default tools
let
    custom_texlive = (pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-basic geometry enumitem titlesec pgf parskip bytefield etoolbox listings latexmk;
    });
in
{
    imports = [
        ./fw13.nix
    ];

    nixpkgs.overlays = [
    	(final: prev: {
	    rofimoji = prev.rofimoji.override {
	    	rofi = prev.rofi-wayland;
	    };
	})
    ];

    boot = {
        tmp.cleanOnBoot = true;
        loader = {
            systemd-boot.enable = true;
            systemd-boot.editor = false;
            timeout = 0;
            efi.canTouchEfiVariables = true;
        };

        kernelPackages = pkgs.linuxPackages_latest;
        kernel.sysctl."vm.swappiness" = 10;
    };

    nix = {
    	settings.allowed-users = [
	    "@wheel"
	];
        settings.auto-optimise-store = true;
        settings.experimental-features = [
            "nix-command"
            "flakes"
        ];
        
        gc.automatic = true;
        gc.dates = "weekly";
        gc.options = "--delete-older-than 14d";
    };

    nixpkgs.config.allowUnfree = true;

    system.autoUpgrade = {
        enable = true;
        allowReboot = false;
        persistent = true;
    };

    networking = {
        networkmanager.enable = true;
	networkmanager.dns = "none";

        useDHCP = lib.mkDefault true;
        firewall.enable = true;
        firewall.allowedTCPPorts = [
            5900 # RFB, for VNC access 
	];

	nameservers = [
	    "1.1.1.1"
	    "9.9.9.9"
	    "1.0.0.1"
	    "8.8.8.8"
	];
    };

    powerManagement = {
        enable = true;
        powertop.enable = true;
    };

    hardware = {
        bluetooth.enable = true;

        graphics = {
            enable = true;
	    enable32Bit = true;
        };
    };

    services = {
        dbus.enable = true;
	hypridle.enable = true;

	avahi = {
	    enable = true;
	    nssmdns4 = true;
	    nssmdns6 = true;
	    publish = {
	    	enable = true;
		addresses = true;
		workstation = true;
	    };
	};

        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };

        openssh = {
            enable = true;
            ports = [ 4444 ];
            banner = (builtins.readFile /etc/issue);
	    extraConfig = ''
	    Match User dean
	    	ForceCommand systemd-inhibit --who=dean --why=active_ssh_session --what=idle --mode=block fish
	    '';
        };

        greetd = {
            enable = true;
	    vt = 2;
            settings = {
                default_session.user = "greeter";
                default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland --issue";
            };
        };
    };

    systemd.services = {
        greetd = {
            unitConfig.After = [ "multi-user.target" ];
            serviceConfig.Type = "idle";
        };
    };

    security = {
        polkit.enable = true;
        rtkit.enable = true;

        sudo = {
            enable = true;
            execWheelOnly = true;
            wheelNeedsPassword = true;
        };
    };

    time.timeZone = "Australia/Sydney";

    fonts = {
        packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-emoji
	    nerd-fonts.fira-mono
        ];

        fontconfig = {
            enable = true;
            defaultFonts = {
                monospace = [ "FiraMono Nerd Font Mono" ];
                serif = [ "Noto Serif" ];
                sansSerif = [ "Noto Sans" ];
            };
        };
    };

    i18n = {
        defaultLocale = "en_GB.UTF-8";
        extraLocaleSettings = {
            LC_ADDRESS = "en_AU.UTF-8";
            LC_IDENTIFICATION = "en_AU.UTF-8";
            LC_MEASUREMENT = "en_AU.UTF-8";
            LC_MONETARY = "en_AU.UTF-8";
            LC_NAME = "en_AU.UTF-8";
            LC_NUMERIC = "en_AU.UTF-8";
            LC_PAPER = "en_AU.UTF-8";
            LC_TELEPHONE = "en_AU.UTF-8";
            LC_TIME = "en_AU.UTF-8";
        };
    };

    environment = {
        sessionVariables = {
            EDITOR = "nvim";
            NIXOS_OZONE_WL = "1";
            NIXOS_XDG_OPEN_USE_PORTAL = "1";
            MOZ_ENABLE_WAYLAND = "1";
            BROWSER = "firefox";
	    MANPAGER = "nvim +Man!";
        };

        etc."greetd/environments".text = "Hyprland";

        systemPackages = with pkgs; [
            # Core utils
            coreutils
            pciutils
            brightnessctl
            man-pages
            man-pages-posix

            # Useful admin tools
            git
            curl
            wget
            htop
            ranger
            unzip
            ntfs3g

            # Desktop
            wl-clipboard
            xdg-utils
            wayvnc
        ];
    };

    programs = {
    	nix-ld.enable = true;
        hyprland.enable = true;
        hyprlock.enable = true;
	waybar.enable = true;
	ssh.startAgent = true;

        fish = {
            enable = true;
            shellInit = "fish_vi_key_bindings \n set fish_greeting";
        };

	neovim = {
	    enable = true;
	    defaultEditor = true;
    	};
    };

    users.users.dean = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [
            "networkmanager"
            "wheel"
        ];

        packages = with pkgs; [
            # background workings
	    dunst
	    hyprpolkitagent
	    hyprpaper
            custom_texlive
            libnotify
            rofi-wayland
	    rofimoji
            grim
            slurp
            killall
            playerctl

            # development
            cmake
            gnumake
            gdb
            gcc
	    pkgsCross.x86_64-embedded.buildPackages.gcc
	    pkgsCross.riscv64-embedded.buildPackages.gcc
	    pkgsCross.m68k.buildPackages.gcc
	    pkgsCross.aarch64-embedded.buildPackages.gcc
            llvmPackages.clangNoLibcxx
            llvmPackages.bintools
            llvmPackages.clang-tools
            llvmPackages.libllvm

            # utils
	    delta
            btop
            ripgrep
            tokei
            xorriso
	    transmission_4
	    fw-ectool
	    ffmpegthumbnailer
	    ffmpeg

            # graphical programs
	    mpv
            qemu
            firefox
            kitty
            gparted
            discord
	    element-desktop
            spotify
            zathura
            vscode
            speedcrunch
            nomacs
        ];
    };

    system.stateVersion = "23.05"; # Did you read the comment?
}
