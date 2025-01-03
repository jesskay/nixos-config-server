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
            echo 'graph_args -l 0'
            echo 'graph_title Flake age'
            echo 'graph_vlabel days'
            echo 'nixpkgs_age.label nixpkgs'
            echo 'nixpkgs_unstable_age.label nixpkgs-unstable'
            echo 'configuration_age.label configuration'
            echo 'graph_scale no'
            echo 'graph_category nix'
            echo 'nixpkgs_age.warning 30'
            echo 'nixpkgs_age.critical 60'
            echo 'nixpkgs_unstable_age.warning 30'
            echo 'nixpkgs_unstable_age.critical 60'
            echo 'graph_info The flake age describes how many days since the last commit to the flakes used to build the current system. For nixpkgs inputs this will typically be at least a few days even after a fresh update, due to the time taken for commits to pass hydra.'
            echo 'nixpkgs_age.info Nixpkgs stable flake age.'
            echo 'nixpkgs_unstable_age.info Nixpkgs unstable flake age.'
            echo 'configuration_age.info System configuration flake age.'
            exit 0
            ;;
        esac

        echo -n "nixpkgs_age.value "
        echo "scale=2; ($(${pkgs.coreutils}/bin/date +%s) - ${toString inputs.nixpkgs.lastModified}) / (60 * 60 * 24)" | ${pkgs.bc}/bin/bc
        echo -n "nixpkgs_unstable_age.value "
        echo "scale=2; ($(${pkgs.coreutils}/bin/date +%s) - ${toString inputs.nixpkgs-unstable.lastModified}) / (60 * 60 * 24)" | ${pkgs.bc}/bin/bc
        echo -n "configuration_age.value "
        echo "scale=2; ($(${pkgs.coreutils}/bin/date +%s) - ${toString inputs.self.lastModified}) / (60 * 60 * 24)" | ${pkgs.bc}/bin/bc
      '';
      extraPlugins.nix_store_count = pkgs.writeScript "nix_store_count"
      ''
        case $1 in
          config)
            echo 'graph_title Nix store size (count)'
            echo 'graph_vlabel count'
            echo 'nix_store_count.label count'
            echo 'graph_category nix'
            echo 'graph_info The number of realized (non-.drv) items currently in the nix store.'
            exit 0
            ;;
        esac

        echo -n 'nix_store_count.value '
        ls -1 /nix/store | ${pkgs.gnugrep}/bin/grep -v '\.drv$' | wc -l
      '';
      extraPlugins.nix_store_bytes = pkgs.writeScript "nix_store_bytes"
      ''
        case $1 in
          config)
            echo 'graph_args --base 1024'
            echo 'graph_title Nix store size (bytes)'
            echo 'graph_vlabel bytes'
            echo 'nix_store_bytes.label bytes'
            echo 'graph_category nix'
            echo 'graph_info The total size in bytes of the nix store.'
            exit 0
            ;;
        esac

        echo -n 'nix_store_bytes.value '
        du -bs /nix/store | cut -f1
      '';
      extraPlugins.munin_graph_count = pkgs.writeScript "munin_graph_count"
      ''
        case $1 in
          config)
            echo 'graph_args -l 0'
            echo 'graph_title Number of graphs'
            echo 'graph_scale no'
            echo 'graph_vlabel graphs'
            echo 'munin_graph_count.label graphs'
            echo 'graph_category why'
            echo 'graph_info The number of graphs on the dashboard.'
            exit 0
            ;;
        esac

        echo -n 'munin_graph_count.value '
        printf 'list\nquit\n' | ${pkgs.netcat}/bin/nc localhost 4949 | ${pkgs.gnugrep}/bin/grep -v '^#' | wc -w
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
