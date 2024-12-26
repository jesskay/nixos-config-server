{
  services.dante = {
    enable = true;
    config = ''
      # listen on tailscale interface, proxy requests out of the wifi interface
      internal: tailscale0 port = 1080
      external: wlp1s0u1u3

      clientmethod: none
      socksmethod: none

      client pass {
        from: 100.0.0.0/8 to: 0.0.0.0/0
        log: error # connect disconnect
      }
      socks pass {
        from: 0.0.0.0/0 to: 0.0.0.0/0
        command: bind connect udpassociate
        log: error # connect disconnect iooperation
      }
      socks pass {
        from: 0.0.0.0/0 to: 0.0.0.0/0
        command: bindreply udpreply
        log: error # connect disconnect iooperation
      }
    '';
  };
}
