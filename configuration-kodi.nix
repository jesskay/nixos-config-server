{ config, pkgs, lib, ... }:
{

  # create a normal user (we don't care about other user info, allow it to be defaulted)
  users.extraUsers.kodi.isNormalUser = true;

  # enable kodi desktop session and automatically log into it on boot as the "kodi" user
  services.xserver.enable = true;
  services.xserver.desktopManager.kodi.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "kodi";
  };

  # open remote interface ports
  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };

  # customize kodi to include packages
  services.xserver.desktopManager.kodi.package = pkgs.kodi.withPackages (p: with p; [
    inputstream-adaptive
    netflix
    youtube
  ]);

}
