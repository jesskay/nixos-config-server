{
  services.ntfy-sh = {
    enable = true;
    settings = {
      upstream-base-url = "https://ntfy.sh";  # use central push backend to avoid unreliable iOS background processing
      base-url = "http://rpi4.raven-ghost.ts.net:8546";
      listen-http = ":8546";
    };
  };
}
