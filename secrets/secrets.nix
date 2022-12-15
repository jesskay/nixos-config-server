let
  userJessPaimon = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjqruCmhDeW4YrVqjzcHi94BcmDbmFdEUHgr4aHiuPdcS2uavmWPeu9xqhsBy+8njUnpJydPReE+XK7nE558ZxBgvIBhRr5s0FEVfdsarnJ5VUBx0e3TRzpXTgwqm2MinPb/Q0NUHGSYuXp2OMtNpMvxamMzifskh+F92b6LVo+2j10RiaigbH5oXbXzeHcZxGavyYggZ8mM2KatzIReVTb6mmzZ+Ct8xQLxkxJZvBfKNVjv0urmDSrpHm/x2J41z6/DQ95TCWs2m/EBmiRgrHs0uETjcEwqHkl1henrmyBGVwr9pJ/FunQuBqCRx/XPQ+v9iMtGyed7GV5LeqJjk5Q==";
  userJessRpi = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRm8GWPVi/G/7dL0s1pkEjoC/0T87k3S037bfXxM/y+PgCsy2vJR6ahldRl9gOJmqEx9cj8igC0kwEKBVKo+jIi5kSTbJVv11kz6AJfV56fQ7KkK6qZBt81CR5WCaVhGV7GVLEVZNC7AonRyRxtbUDZkk3Pm5/4v5eS2zDem/5KA6+5CBAvACheCTLvuJoDbPpNiZm03pK388I2BLwMk7/mg0kSn4o2Err2R8oX9qpp4ZP4s1Ltphn3WAVKPhA8Pg9OFipz3elZPtRz91GC0VZhKwMUn69/xmbbA4IW1t/KOdFjl2EwSoqyJarKlfK8G4eas/S5A02nm+zntQ3N9lr6F/rDUL+d0utJWsvWwoDN7mPa3YrqYZXmv41vKVyxCk6143NoCq0UcGR5BPcgaphc99w/QWKcUklmBiRMYhbIBmX/aeeXrXRvUfKoDaesyFLhmC+LJU3ZKA34LxdZd5rtveRoJXVfs7ZfVvNadu9xk//Oh3I9uTymO6PR3AD2XE=";
  users = [ userJessPaimon userJessRpi ];

  sysRpi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOfHT68l0rPZX3k3tKnSbv2R9ytJm6XHA9F2g+oALIoE";
  systems = [ sysRpi ];
in
{
  "wireless.age".publicKeys = users ++ systems;
  "freshrss.age".publicKeys = users ++ systems;
}
