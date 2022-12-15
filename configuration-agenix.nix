{ config, pkgs, lib, ... }:
{
  age.secrets.wireless.file = ./secrets/wireless.age;
  age.secrets.freshrss.file = ./secrets/freshrss.age;
}
