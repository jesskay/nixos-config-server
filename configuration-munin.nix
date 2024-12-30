{ config, pkgs, inputs, ... }:

{
  services = {
    munin-node = {
      enable = true;
      disabledPlugins = [
        "buddyinfo"
        "cpuspeed"
        "df_inode"
        "diskstat_*"
        "diskstats"
        "entropy"
        "if_*"
        "interrupts"
        "irqstats"
        "forks"
        "fw_packets"
        "meminfo"
        "munin_stats"
        "port_*"
        "netstat"
        "nfs_client"
        "nfs4_client"
        "open_files"
        "open_inodes"
        "proc"
        "proc_pri"
        "processes"
        "swap"
        "tcp"
        "threads"
        "users"
        "vmstat"
      ];
      extraPluginConfig = ''
        [df]
        env.exclude none unknown rootfs iso9660 squashfs udf romfs ramfs debugfs cgroup_root devtmpfs tmpfs

        [df_abs]
        env.exclude none unknown rootfs iso9660 squashfs udf romfs ramfs debugfs cgroup_root devtmpfs tmpfs
      '';
      extraPlugins.nixpkgs_age = pkgs.writeScript "nixpkgs_age"
      ''
        case $1 in
          config)
            echo 'graph_title Nixpkgs age'
            echo 'graph_vlabel days'
            echo 'nixpkgs_age.label age'
            echo 'graph_category system'
            echo 'nixpkgs_age.warning 30'
            echo 'nixpkgs_age.critical 60'
            echo 'graph_info The nixpkgs age describes how many days since the last commit to the nixpkgs instance used to build the current system. This will typically be at least a few days even after a fresh update, due to the time taken for commits to pass hydra.'
            echo 'nixpkgs_age.info Nixpkgs age for the five minutes.'
            exit 0
            ;;
        esac

        echo -n "nixpkgs_age.value "
        echo "scale=2; ($(${pkgs.coreutils}/bin/date +%s) - ${toString inputs.nixpkgs.lastModified}) / (60 * 60 * 24)" | ${pkgs.bc}/bin/bc
      '';
    };

    munin-cron = {
      enable = true;
      hosts = ''
        [${config.networking.hostName}]
        address localhost
      '';
      extraGlobalConfig = ''
        contact.ntfy.command ${pkgs.curl}/bin/curl -H "Title: Munin alert" -H "Tags: warning" -T - localhost:8546/munin_alerts
        contact.email.command ${pkgs.msmtp}/bin/msmtp --host=smtp.fastmail.com --port=465 --auth --tls --tls-starttls=off --user='psquid@psquid.net' --passwordeval='cat ${config.age.secrets.munin-email.path}' -f 'munin@psquid.net' 'munin@psquid.net'
      '';
    };

    nginx.simpleVhosts."munin.psquid.net" = {
      vhostType = "static";
      webroot = "/var/www/munin";
    };
  };
}
