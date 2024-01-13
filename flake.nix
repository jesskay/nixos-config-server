{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

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

            # This is a config that assumes 22.11's config defaults
            system.stateVersion = "22.11";

            # Make `inputs` into a module argument for any that want it (e.g., for registry).
            _module.args.inputs = inputs;

            # Make the platform-specific nixpkgs-unstable into a module argument, for portability of modules.
            _module.args.pkgs-unstable = nixpkgs-unstable.legacyPackages.aarch64-linux;

            hardware.enableRedistributableFirmware = true;

            boot.loader.grub.enable = false;
            boot.loader.generic-extlinux-compatible.enable = true;
            boot.kernelPackages = pkgs.linuxPackages_rpi4;
            boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
            boot.tmpOnTmpfs = true;

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
          ./configuration-freshrss.nix
          ./configuration-network-rpi4.nix
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

    nixosConfigurations.phoenix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ ({ pkgs, ... }: {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            # This is a config that assumes 22.11's config defaults
            system.stateVersion = "22.11";

            # Make `inputs` into a module argument for any that want it (e.g., for registry).
            _module.args.inputs = inputs;

            # Make the platform-specific nixpkgs-unstable into a module argument, for portability of modules.
            _module.args.pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;

            # General hardware-specific stuff
            hardware.enableRedistributableFirmware = true;
            hardware.cpu.intel.updateMicrocode = true;
            boot.initrd.availableKernelModules = [ "ata_piix" "virtio_pci" "virtio_scsi" "xhci_pci" "sd_mod" "sr_mod" ];
            boot.initrd.kernelModules = [ ];
            boot.kernelModules = [ ];
            boot.extraModulePackages = [ ];

            # Install GRUB in hybrid BIOS/UEFI mode
            # - Hetzner seems to only use BIOS currently, so this is futureproofing
            boot.loader.grub.devices = [ "/dev/sda" ];
            boot.loader.grub.enable = true;
            boot.loader.grub.version = 2;
            boot.loader.grub.efiSupport = true;
            boot.loader.grub.efiInstallAsRemovable = true;

            # Use tmpfs for tmp
            boot.tmpOnTmpfs = true;

            fileSystems = {
              "/" = {
                device = "/dev/disk/by-label/NIXOS_ROOT";
                fsType = "btrfs";
              };

              "/boot" = {
                device = "/dev/disk/by-label/EFI";
                fsType = "vfat";
              };
            };

            swapDevices = [ { device = "/dev/disk/by-label/SWAP"; } ];

            environment.systemPackages = with pkgs; [
              agenix.packages.x86_64-linux.agenix
            ];
          })
          
          # local modules
          ./configuration-agenix.nix
          ./configuration-basic-env.nix
          ./configuration-freshrss.nix
          ./configuration-network-phoenix.nix
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
