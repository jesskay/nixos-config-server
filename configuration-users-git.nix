{ config, pkgs, lib, ... }:
{
  users.users.git = {
    isSystemUser = true;
    description = "git-shell user";
    home = "/srv/git";
    createHome = true;
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjqruCmhDeW4YrVqjzcHi94BcmDbmFdEUHgr4aHiuPdcS2uavmWPeu9xqhsBy+8njUnpJydPReE+XK7nE558ZxBgvIBhRr5s0FEVfdsarnJ5VUBx0e3TRzpXTgwqm2MinPb/Q0NUHGSYuXp2OMtNpMvxamMzifskh+F92b6LVo+2j10RiaigbH5oXbXzeHcZxGavyYggZ8mM2KatzIReVTb6mmzZ+Ct8xQLxkxJZvBfKNVjv0urmDSrpHm/x2J41z6/DQ95TCWs2m/EBmiRgrHs0uETjcEwqHkl1henrmyBGVwr9pJ/FunQuBqCRx/XPQ+v9iMtGyed7GV5LeqJjk5Q== DIAMOND"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwI9mhy9tkKnHbqpqKOKgN5ioFiwUcrH+R3zVSp468xytAEctbiHMPTfNmsZwK/cCd5zy8DDYWsshfn8JuxRswPIlmt+mICviXm1KL1UNJvPBGusLR/pMu805q7n46P3kBhr2i6wqF2Mr5lGZ8sgiLQdGOeDKoMs0Co7U9XBhjVmqvIMFs32sgQsuX0pjd8O82hBK4fndVwQ7PcdKVI5M3/puCPUzOyykzeKlsPYjJYAhO4T9Mce++ZTsOuZxFwrYRTpHRm3ldrawVTTWJyZgOFufoA/7Et0WODhqjKeRLxqo5le768W4ZhCwGnSdbInLRXG+qA7Urcql1hPyQZTv4CuJDqGlrlEB8zwUNL2XOUthF1DLzFtp/JzYe2AK1viFBOZ6CShTJxnXpWAalxdS61nlqQywfHfFSnFcnYZwKVU8YS3O61DnNdR/UttvvO5fyduUUWn8DasJyxoYt+aC70xP6zw6pJema8bM9EQO/kY4YNNeBmGnx4uWoeq6sXEE= u0_a358@localhost"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRm8GWPVi/G/7dL0s1pkEjoC/0T87k3S037bfXxM/y+PgCsy2vJR6ahldRl9gOJmqEx9cj8igC0kwEKBVKo+jIi5kSTbJVv11kz6AJfV56fQ7KkK6qZBt81CR5WCaVhGV7GVLEVZNC7AonRyRxtbUDZkk3Pm5/4v5eS2zDem/5KA6+5CBAvACheCTLvuJoDbPpNiZm03pK388I2BLwMk7/mg0kSn4o2Err2R8oX9qpp4ZP4s1Ltphn3WAVKPhA8Pg9OFipz3elZPtRz91GC0VZhKwMUn69/xmbbA4IW1t/KOdFjl2EwSoqyJarKlfK8G4eas/S5A02nm+zntQ3N9lr6F/rDUL+d0utJWsvWwoDN7mPa3YrqYZXmv41vKVyxCk6143NoCq0UcGR5BPcgaphc99w/QWKcUklmBiRMYhbIBmX/aeeXrXRvUfKoDaesyFLhmC+LJU3ZKA34LxdZd5rtveRoJXVfs7ZfVvNadu9xk//Oh3I9uTymO6PR3AD2XE= jess@rpi4"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCprato6I+IG0XcT/js8d7L9wU7Itx+Ff5WpsmTXdUoNpJ0zx8ZD1Slvv7wdat6U8qiy3KNpGJQgZ3zkM+s5j21J8gQnqb3zjlhZrW3BLSviayuU+DMHWZ+U36cuOLzuYIuZ8TUuWjFXiE4mL0Dn4PrEmY9FnMypoK+3AILXm9RYWsxR/NmsM4Sk68sCR1qgeklVPVcDEgjCD1w/z+plw91YZ8kd9WCBBffwN3yEidfPXVOMymb5cmoqOvh5vK6iKf+VzV6OUJT9Bz07AvwsY2SAG85/7/wd3WwVDW+ZbBcRZ/1hwMtaxCS67o0LdIRs7mQor+A7N7uOu36/Vin7d1HFRx/lMZRyarAuD1Vi/2ae4pt9bvj465djs6GE8z8Ew1LQBj5vMWPCsjZ/K5WrRClhg55RbRLyKaoEJnv3iW9f73jr7GBQnTXK4VuVzbJA7e9BoRjbrIb/hHFyxDg3EYV/3LLDxvv1y2UJ2bUeBA1Akk/IUhr5oucUAZWL7WYgO0= root@rpi4"
    ];
  };
}

