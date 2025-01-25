{ pkgs, ... }: 

let

  sources = import ../../sources.nix;

in

{

  imports = [
    # services
    ../../services/calibre-web
    ../../services/freshrss
    ../../services/home-assistant
    ../../services/munin
    ../../services/ntfy
    ../../services/sites
    ../../services/syncthing
    ../../services/tailscale

    # users
    ../../users/jess

    # networking configuration
    ./network.nix

    # system-wide programs
    ../../programs/neovim
    ../../programs/starship
    ../../programs/tmux

    # nix configuration
    ../../nix

    # option-provider modules
    ../../modules/simple-nginx

    # external modules
    "${sources.agenix}/modules/age.nix"
    "${sources.nixos-hardware}/raspberry-pi/4"
  ];

  # set hostname
  networking.hostName = "rpi4";

  # enable SSH
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # allow sudo without password for %wheel
  security.sudo.wheelNeedsPassword = false;

  # This is a config that uses 23.11 state where relevant
  system.stateVersion = "23.11";

  hardware.enableRedistributableFirmware = true;

  # configure as a grub-based EFI install
  boot.loader.generic-extlinux-compatible.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = false;

  # use the upstream (not rpi) kernel
  boot.kernelPackages = pkgs.linuxPackages;

  # allow USB HID and storage (latter required as the system drive is connected via USB) in initrd
  boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" "uas" ];

  # clean /tmp on boot
  boot.tmp.cleanOnBoot = true;

  # do not enable hibernation
  boot.kernelParams = [
    "nohibernate"
  ];

  # enable bluetooth
  hardware.bluetooth.enable = true;

  # configure root on USB-attached SSD, /boot on microSD
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };

  # configure swap file
  swapDevices = [ { device = "/swap"; } ];

  # add rpi tools and agenix to PATH
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    (pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" {})
  ];

}
