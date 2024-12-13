{ config, lib, pkgs, modulesPath, ... }:

{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
    environment.etc.issue.text = ''
Welcome to

░▒█░░▒█░░▀░░█▀▀▄░▀█▀░█▀▀░█▀▀▄░▒█▀▄▀█░█░▒█░▀█▀░█▀▀
░▒█▒█▒█░░█▀░█░▒█░░█░░█▀▀░█▄▄▀░▒█▒█▒█░█░▒█░░█░░█▀▀
░▒▀▄▀▄▀░▀▀▀░▀░░▀░░▀░░▀▀▀░▀░▀▀░▒█░░▒█░░▀▀▀░░▀░░▀▀▀
    '';

    networking.hostName = "wintermute";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

    hardware = {
        acpilight.enable = true;
        sensor.iio.enable = true;
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        graphics.extraPackages = with pkgs; [
            intel-media-driver
            vaapiIntel
            vaapiVdpau
            libvdpau-va-gl
        ];
    };

    boot = {
        initrd.availableKernelModules = [
            "xhci_pci"
            "thunderbolt"
            "nvme"
            "usb_storage"
            "sd_mod"
        ];

        kernelModules = [
            "kvm-intel"
            "acpi_call"
        ];

        extraModulePackages = [
            config.boot.kernelPackages.acpi_call
        ];

        blacklistedKernelModules = [
            "hid-sensor-hub"
        ];

        kernelParams = [
            "mem_sleep_default=deep"
            "i915.enable_psr=1"
        ];
    };

    services = {
        fprintd.enable = true;
        fstrim.enable = true;
        fwupd.enable = true;
    };

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-uuid/6d77718b-5bb5-469e-9165-237774642c72";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-uuid/A430-B0CF";
            fsType = "vfat";
        };
    };
}
