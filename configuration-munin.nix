{ config, pkgs, ... }:

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
