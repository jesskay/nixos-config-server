{ config, pkgs, lib, ... }:
{
  # pull the git user in separately so that can be reused
  imports = [
    ./configuration-users-git.nix
  ];

  security.sudo.wheelNeedsPassword = false;

  users.users.jess = {
    isNormalUser = true;
    home = "/home/jess";
    description = "Jessica Kay";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjqruCmhDeW4YrVqjzcHi94BcmDbmFdEUHgr4aHiuPdcS2uavmWPeu9xqhsBy+8njUnpJydPReE+XK7nE558ZxBgvIBhRr5s0FEVfdsarnJ5VUBx0e3TRzpXTgwqm2MinPb/Q0NUHGSYuXp2OMtNpMvxamMzifskh+F92b6LVo+2j10RiaigbH5oXbXzeHcZxGavyYggZ8mM2KatzIReVTb6mmzZ+Ct8xQLxkxJZvBfKNVjv0urmDSrpHm/x2J41z6/DQ95TCWs2m/EBmiRgrHs0uETjcEwqHkl1henrmyBGVwr9pJ/FunQuBqCRx/XPQ+v9iMtGyed7GV5LeqJjk5Q== DIAMOND"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwI9mhy9tkKnHbqpqKOKgN5ioFiwUcrH+R3zVSp468xytAEctbiHMPTfNmsZwK/cCd5zy8DDYWsshfn8JuxRswPIlmt+mICviXm1KL1UNJvPBGusLR/pMu805q7n46P3kBhr2i6wqF2Mr5lGZ8sgiLQdGOeDKoMs0Co7U9XBhjVmqvIMFs32sgQsuX0pjd8O82hBK4fndVwQ7PcdKVI5M3/puCPUzOyykzeKlsPYjJYAhO4T9Mce++ZTsOuZxFwrYRTpHRm3ldrawVTTWJyZgOFufoA/7Et0WODhqjKeRLxqo5le768W4ZhCwGnSdbInLRXG+qA7Urcql1hPyQZTv4CuJDqGlrlEB8zwUNL2XOUthF1DLzFtp/JzYe2AK1viFBOZ6CShTJxnXpWAalxdS61nlqQywfHfFSnFcnYZwKVU8YS3O61DnNdR/UttvvO5fyduUUWn8DasJyxoYt+aC70xP6zw6pJema8bM9EQO/kY4YNNeBmGnx4uWoeq6sXEE= u0_a358@localhost"
    ];
  };
}
