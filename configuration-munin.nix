{ config, ... }:

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
    };

    munin-cron = {
      enable = true;
      hosts = ''
        [${config.networking.hostName}]
        address localhost
      '';
    };
  };
}
