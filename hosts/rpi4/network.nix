{ config, ... }:

{

  # build kernel module for USB wifi adapter
  boot.extraModulePackages = with config.boot.kernelPackages; if (kernelOlder "6.13") then [ rtw88 ] else [];

  # EXPERIMENTAL: disable deep power-saving for rtw drivers, as it may be connected to occasional instability
  boot.extraModprobeConfig = ''
    options rtw_core disable_lps_deep=y
    options rtw88_core disable_lps_deep=y
  '';

  # configure wifi using PSKs from agenix
  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlp1s0u1u3" ];
  networking.wireless.networks = {
    "TP-LINK_7C8B_5G" = {
      pskRaw = "ext:PSK_RAW_5G";
      priority = 10;
    };
    "TP-LINK_7C8B" = {
      pskRaw = "ext:PSK_RAW";
      priority = 1;
    };
  };
  age.secrets.wireless.file = ../../secrets/wireless.age;
  networking.wireless.secretsFile = config.age.secrets.wireless.path;

  # use cloudflare DNS, with fallback to google DNS
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

}
