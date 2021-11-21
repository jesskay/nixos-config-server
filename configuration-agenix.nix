{ config, pkgs, lib, ... }:
{
  imports = [
    # bootstrap this with -I agenix=https://github.com/ryantm/agenix/archive/main.tar.gz on first build
    <agenix/modules/age.nix>
  ];

  environment.systemPackages = with import <agenix> {}; [ agenix ];

  age.secrets.wireless.file = ./secrets/wireless.age;
}
