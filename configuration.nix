{ config, pkgs, lib, ... }:
{
  imports = [
    ./configuration-agenix.nix
    ./configuration-basic-env.nix
    ./configuration-network.nix
    ./configuration-nix.nix
    ./configuration-users.nix
    ./configuration-web.nix
  ];

  ## Machine-specific basic config here. Everything else is composed from modules above.
  hardware.enableRedistributableFirmware = true;
  hardware.pulseaudio.enable = true;

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.loader.raspberryPi = {
    enable = true;
    version = 4;
    uboot.enable = true;
    firmwareConfig = ''
      dtparam=audio=on
    '';
  };

  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
  boot.tmpOnTmpfs = true;
  boot.kernelParams = [
    "8250.nr_uarts=1"
    "console=ttyAMA0,115200"
    "console=tty1"
    "cma=128M"
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  swapDevices = [ { device = "/swap"; } ];

  environment.systemPackages = with pkgs; [ libraspberrypi ];
}
