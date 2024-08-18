{ config, pkgs, lib, ... }:
let 

  cfg = config.services.syncthing;

in

{
  fileSystems.${cfg.dataDir} = {
    device = "/dev/disk/by-label/volume-hel1-1";
    fsType = "btrfs";
    options = [
      "discard"
      "defaults"
      "subvol=@syncthing"
    ];
  };

  users.users.jess.extraGroups = [ cfg.group ];

  services.syncthing = {
    enable = true;
    overrideFolders = false;      # allow to configure folders imperatively via web GUI
    openDefaultPorts = true;      # opens only the syncing and discovery ports, NOT the web gui port
    guiAddress = "0.0.0.0:8384";  # listen on all interfaces (should be safe as port is not opened)
  };
}

