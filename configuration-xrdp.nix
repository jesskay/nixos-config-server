{

  services.xrdp = {
    enable = true;
    defaultWindowManager = "xfce4-session";
  };

  services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    xkb.layout = "gb";
  };

}
