{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";

  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.agenix.url = "github:ryantm/agenix";
  inputs.agenix.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, nixpkgs-unstable, agenix, ... }@inputs : {

    nixosConfigurations.rpi4 = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules =
        [ ({ pkgs, ... }: {
            # disable nixos-21.11 tailscale module
            disabledModules = [ "services/networking/tailscale.nix" ];

            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            # Make `inputs` into a module argument for any that want it (e.g., for registry).
            _module.args.inputs = inputs;

            # Make the platform-specific nixpkgs-unstable into a module argument, for portability of modules.
            _module.args.pkgs-unstable = nixpkgs-unstable.legacyPackages.aarch64-linux;

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

          "${nixpkgs-unstable}/nixos/modules/services/networking/tailscale.nix"

          agenix.nixosModules.age
        ];
    };

  };
}
