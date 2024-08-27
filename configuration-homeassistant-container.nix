{ config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.backend = "podman";

  virtualisation.oci-containers.containers.homeassistant = {
    volumes = [
      "home-assistant:/config"
    ];
    environment.TZ = "Europe/London";
    image = "ghcr.io/home-assistant/home-assistant:stable";
    extraOptions = [
      "--network=host"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 8123 ];
}
