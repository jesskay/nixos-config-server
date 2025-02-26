{ config, ... }:

let

  hostname = "reader.psquid.net";

in

{

  services.miniflux = {

    enable = true;

    config = {
      # Set the app's base URL based on hostname
      BASE_URL = "https://${hostname}/";

      # Don't clean up old entries automatically
      CLEANUP_ARCHIVE_READ_DAYS = -1;
      CLEANUP_ARCHIVE_UNREAD_DAYS = -1;

      # Fetch youtube watch time as estimated reading time
      FETCH_YOUTUBE_WATCH_TIME = 1;

      # Queue up to 150 qualifying feeds every 5 minutes
      BATCH_SIZE = 150;
      POLLING_FREQUENCY = 5;

      # Retry an erroring feed up to 10 times before marking it broken
      POLLING_PARSING_ERROR_LIMIT = 10;

      # Select qualifying feeds via round-robin, with a minimum refresh
      # interval of an hour for each feed.
      POLLING_SCHEDULER = "round_robin";
      SCHEDULER_ROUND_ROBIN_MIN_INTERVAL = 1 * 60;

      # Enable Webauthn/Passkey authentication
      WEBAUTHN = 1;
    };

    adminCredentialsFile = config.age.secrets.miniflux-admin.path;

  };

  age.secrets.miniflux-admin.file = ../../secrets/miniflux-admin.age;

  services.nginx.simpleVhosts."${hostname}" = {
    vhostType = "proxy";
    port = 8080;
  };

}
