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
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            # Make `inputs` into a module argument for any that want it (e.g., for registry).
            _module.args.inputs = inputs;

            # Make the platform-specific nixpkgs-unstable into a module argument, for portability of modules.
            _module.args.pkgs-unstable = nixpkgs-unstable.legacyPackages.aarch64-linux;

            hardware.enableRedistributableFirmware = true;
            hardware.pulseaudio.enable = true;
            hardware.bluetooth = {
              enable = true;
              package = nixpkgs.legacyPackages.aarch64-linux.bluez;
              powerOnBoot = false;
            };

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
            boot.kernelParams = nixpkgs.lib.mkForce [
              "console=ttyS0,115200n8"
              "console=tty0"
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
          
          # local modules
          ./configuration-agenix.nix
          ./configuration-basic-env.nix
          ./configuration-network.nix
          ./configuration-nix.nix
          ./configuration-users.nix
          ./configuration-web.nix

          # upstream modules from a newer nixos (current module must be disabled if present in both versions)
          "${nixpkgs-unstable}/nixos/modules/services/networking/tailscale.nix"  # replacement
          "${nixpkgs-unstable}/nixos/modules/programs/starship.nix"              # addition

          # inline module to disable nixos-21.11 modules where required
          (_: { disabledModules = [
            "services/networking/tailscale.nix"
          ]; })

          # external modules
          agenix.nixosModules.age
        ];
    };

  };
}
