{ config, ... }:

{

  # use cloudflare DNS, with fallback to google DNS
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

}
