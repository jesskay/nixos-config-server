{ config, lib, pkgs, ... }:
{
  hardware.deviceTree.overlays = [
    {
      name = "bluetooth-overlay";
      dtsText = ''
        /dts-v1/;
        /plugin/;

        / {
            compatible = "brcm,bcm2711";

            fragment@0 {
                target = <&uart0_pins>;
                __overlay__ {
                        brcm,pins = <30 31 32 33>;
                        brcm,pull = <2 0 0 2>;
                };
            };
        };
      '';
    }
  ];

  hardware.bluetooth.enable = true;
  systemd.services.btattach = {
    before = [ "bluetooth.service" ];
    after = [ "dev-ttyAMA0.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
    };
  };
}
