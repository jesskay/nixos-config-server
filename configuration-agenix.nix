{ config, pkgs, lib, ... }:
{
  age.secrets.wireless.file = ./secrets/wireless.age;
}
