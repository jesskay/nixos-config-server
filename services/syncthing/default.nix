{ config, ... }:

let 

  syncthing = config.services.syncthing;

in

{

  # Add regular user to syncthing's group
  users.users.jess.extraGroups = [ syncthing.group ];

  # Ensure permissions are correct on the data dirs for group access
  systemd.services.syncthing.serviceConfig.UMask = "0007";
  systemd.tmpfiles.rules = [
    "d ${syncthing.dataDir} 0750 ${syncthing.user} ${syncthing.group}"          # ensure base dir exists and is u=rwx,g=rw
    "z ${syncthing.dataDir}/*/ 2770 ${syncthing.user} ${syncthing.group}"       # set all topdirs to u=rwx,g=rws
    "Z ${syncthing.dataDir}/*/* 0770 ${syncthing.user} ${syncthing.group}"      # set files in topdirs to u=rwx,g=rwx (recursive)
    "Z ${syncthing.dataDir}/.config 0700 ${syncthing.user} ${syncthing.group}"  # ...except .config, which is u=rwx only (recursive)
  ];

  # Configure syncthing itself
  services.syncthing = {
    enable = true;
    overrideFolders = false;      # disable declarative folders, to allow configuring folders imperatively via web GUI
    openDefaultPorts = true;      # opens only the syncing and discovery ports, NOT the web gui port
    guiAddress = "0.0.0.0:8384";  # listen on all interfaces (should be safe as port is not opened)
  };

}


