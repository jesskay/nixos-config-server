{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";

  inputs.agenix.url = "github:ryantm/agenix";

  outputs = { self, nixpkgs, agenix, ... }@inputs : {

    nixosConfigurations.rpi4 = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules =
        [ ({ pkgs, ... }: {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            # Make `inputs` into a module argument for any that want it (e.g., for registry).
            _module.args.inputs = inputs;

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

            environment.systemPackages = with pkgs; [
              libraspberrypi
              agenix.packages.aarch64-linux.agenix
            ];
          })
          
          ./configuration-agenix.nix
          ./configuration-basic-env.nix
          ./configuration-network.nix
          ./configuration-nix.nix
          ./configuration-users.nix
          ./configuration-web.nix

          agenix.nixosModules.age
        ];
    };

  };
}
