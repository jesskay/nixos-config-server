{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.agenix.url = "github:ryantm/agenix";
  inputs.agenix.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  outputs = { self, nixpkgs, nixpkgs-unstable, agenix, nixos-hardware, ... }@inputs : {

    nixosConfigurations.rpi4 = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules =
        [ ({ pkgs, ... }: {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            # This is a config that uses 23.11 state where relevant
            system.stateVersion = "23.11";

            # Make `inputs` into a module argument for any that want it (e.g., for registry).
            _module.args.inputs = inputs;

            # Make the platform-specific nixpkgs-unstable into a module argument, for portability of modules.
            _module.args.pkgs-unstable = nixpkgs-unstable.legacyPackages.aarch64-linux;

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
              agenix.packages.aarch64-linux.agenix
            ];
          })
          
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

          # upstream modules from a newer nixos (current module must be disabled below if present in both versions)
          # : modules paths as strings: "${nixpkgs-unstable}/nixos/modules/path/to/module.nix"

          # inline module to disable nixos-stable modules where required
          # : list of paths relative to $REPO/nixos/modules/
          (_: { disabledModules = [ ]; })

          # external modules
          agenix.nixosModules.age
	  nixos-hardware.nixosModules.raspberry-pi-4
        ];
    };

  };
}
