{ config, pkgs, lib, ... }:
{
  services.cage = {
    enable = true;
    user = "jess";
    program = "${pkgs.emulationstation}/bin/emulationstation";
  };
}
