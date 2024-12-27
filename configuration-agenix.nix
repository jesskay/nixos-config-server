{ config, pkgs, lib, ... }:
{
  age.secrets.wireless.file = ./secrets/wireless.age;
  age.secrets.freshrss.file = ./secrets/freshrss.age;
  age.secrets.munin-email = {
    file = ./secrets/munin-email.age;
    mode = "770";
    owner = "munin";
    group = "munin";
  };
}
