{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

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

            # This is a config that assumes 22.05's config defaults
            system.stateVersion = "22.05";

            # Revert oci-containers to 21.11's default (docker) - possibly migrate to podman later?
            virtualisation.oci-containers.backend = "docker";

            # Make `inputs` into a module argument for any that want it (e.g., for registry).
            _module.args.inputs = inputs;

            # Make the platform-specific nixpkgs-unstable into a module argument, for portability of modules.
            _module.args.pkgs-unstable = nixpkgs-unstable.legacyPackages.aarch64-linux;

            hardware.enableRedistributableFirmware = true;
            hardware.pulseaudio = {
              enable = true;
              package = pkgs.pulseaudioFull;
            };
            hardware.bluetooth = {
              enable = true;
              package = pkgs.bluez;
              powerOnBoot = false;
            };
            hardware.opengl = {
              enable = true;
              driSupport = true;
              extraPackages = [ pkgs.mesa.drivers ];
            };

            boot.loader.grub.enable = false;
            boot.loader.raspberryPi = {
              enable = true;
              version = 4;
              firmwareConfig = ''
                dtparam=audio=on
              '';
            };

            boot.kernelPackages = pkgs.linuxPackages_latest;
            hardware.deviceTree.filter = "bcm2711-rpi-4-b.dtb";
            boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
            boot.tmpOnTmpfs = true;
            boot.kernelParams = nixpkgs.lib.mkForce [
              "console=ttyS0,115200n8"
              "console=tty0"
            ];
            systemd.services."getty@".enable = false;

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

          # upstream modules from a newer nixos (current module must be disabled below if present in both versions)
          # : modules paths as strings: "${nixpkgs-unstable}/nixos/modules/path/to/module.nix"

          # inline module to disable nixos-stable modules where required
          # : list of paths relative to $REPO/nixos/modules/
          (_: { disabledModules = [ ]; })

          # external modules
          agenix.nixosModules.age
        ];
    };

  };
}
