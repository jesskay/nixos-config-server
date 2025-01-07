{ pkgs, ... }: 

let
  sources = builtins.mapAttrs
    (src-name: src: builtins.fetchTree { type = "git"; url = src.url; rev = src.rev; narHash = src.narHash; })
    (builtins.fromJSON (builtins.readFile ./sources.json));

in

{

  imports = [
    # local modules
    ./configuration-agenix.nix
    ./configuration-basic-env.nix
    ./configuration-freshrss.nix
    ./configuration-homeassistant-container.nix
    ./configuration-munin.nix
    ./configuration-network-rpi4.nix
    ./configuration-nix.nix
    ./configuration-ntfy.nix
    ./configuration-syncthing.nix
    ./configuration-users.nix
    ./configuration-web.nix

    # external modules
    "${sources.agenix}/modules/age.nix"
    "${sources.nixos-hardware}/raspberry-pi/4"
  ];

  # This is a config that uses 23.11 state where relevant
  system.stateVersion = "23.11";

  hardware.enableRedistributableFirmware = true;

  boot.loader.generic-extlinux-compatible.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = false;
  boot.kernelPackages = pkgs.linuxPackages;
  boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" "uas" ];
  boot.tmp.cleanOnBoot = true;
  boot.kernelParams = [
    "nohibernate"
  ];

  hardware.bluetooth.enable = true;

  services.hardware.argonone.enable = true;

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

  swapDevices = [ { device = "/swap"; } ];

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    (pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" {})
  ];

}
