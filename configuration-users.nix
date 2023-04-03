{ config, pkgs, lib, ... }:
{
  security.sudo.wheelNeedsPassword = false;

  users.users.jess = {
    isNormalUser = true;
    home = "/home/jess";
    description = "Jessica Kay";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjqruCmhDeW4YrVqjzcHi94BcmDbmFdEUHgr4aHiuPdcS2uavmWPeu9xqhsBy+8njUnpJydPReE+XK7nE558ZxBgvIBhRr5s0FEVfdsarnJ5VUBx0e3TRzpXTgwqm2MinPb/Q0NUHGSYuXp2OMtNpMvxamMzifskh+F92b6LVo+2j10RiaigbH5oXbXzeHcZxGavyYggZ8mM2KatzIReVTb6mmzZ+Ct8xQLxkxJZvBfKNVjv0urmDSrpHm/x2J41z6/DQ95TCWs2m/EBmiRgrHs0uETjcEwqHkl1henrmyBGVwr9pJ/FunQuBqCRx/XPQ+v9iMtGyed7GV5LeqJjk5Q== DIAMOND"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwI9mhy9tkKnHbqpqKOKgN5ioFiwUcrH+R3zVSp468xytAEctbiHMPTfNmsZwK/cCd5zy8DDYWsshfn8JuxRswPIlmt+mICviXm1KL1UNJvPBGusLR/pMu805q7n46P3kBhr2i6wqF2Mr5lGZ8sgiLQdGOeDKoMs0Co7U9XBhjVmqvIMFs32sgQsuX0pjd8O82hBK4fndVwQ7PcdKVI5M3/puCPUzOyykzeKlsPYjJYAhO4T9Mce++ZTsOuZxFwrYRTpHRm3ldrawVTTWJyZgOFufoA/7Et0WODhqjKeRLxqo5le768W4ZhCwGnSdbInLRXG+qA7Urcql1hPyQZTv4CuJDqGlrlEB8zwUNL2XOUthF1DLzFtp/JzYe2AK1viFBOZ6CShTJxnXpWAalxdS61nlqQywfHfFSnFcnYZwKVU8YS3O61DnNdR/UttvvO5fyduUUWn8DasJyxoYt+aC70xP6zw6pJema8bM9EQO/kY4YNNeBmGnx4uWoeq6sXEE= u0_a358@localhost"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDD9hmOf4UAXId8QopYaNnzakzwbO5wSW3/gRjYvxzfm49lVAzMM/WE6Z/OJwJcVrYeSsiBOXhWqhzSAhcR4QGtiw/HHZnfjqc/bgqSq3e6l9l3qluwjZKWhTy3c07gqsnE9nETRbX0gfr4AV4xZxB+pA/klhc0iV7oJHxBUUGi9a+luBUsjA4f4BQqu9z06m4RX6fBcJ8y8a8/HoBYYvVznAJMLCEdtsUKCEOMd9Vq9A8QojCPYN1JfI0yVEo7ptrFIT0cNK3/iI4pnt1vtne45cI7Y7qDtJk2/wijge/VpvN4QlnztrV/en2jk+HpGIn0tWiMUZVXDrvdWMXgTfJ3IBQ2axmp7VmfF6IxtHa9CxmPqZdvRIsxYThvW2x5OuPJUtYQjao395oPeVJ2+KFSdr1MqiBNNQpvHWs51JeQ2QblN2nKWa30XzX74Y4xzwbgXXK6XiEhTGYz6PW5YqSb/KmYm1ORzg9RsHN89GNUrn+iRU3L9r6SOdoolgxxOEU= u0_a292@localhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKbKTZqadaRuZih1HELyaVQXSxI0p6jj90f+Iqjhhf6M ed25519-key-20220729"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoZB9gm4v2V+ucQdcB5bET43xvWRuSbqSAyxeBmbzoh ipadmini"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKVwjO9bl44mDJU1BU2pjHzG7sBgd1/SASs4twNPBtnhAAAABHNzaDo= jess@paimon"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNlbD3M/P430r5JgrbriC6H2dKUSuIflEouucsNwNR0cWQVYorpyn/hR6APsav6q9HaiHQPramKwCP7e2/3N2us= ShellFish@iPhone-30102022"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIG1CFr4n1Az90LblfLhb8kLH5KK57X+/voRCIOOJgUWKAAAABHNzaDo= jess@paimon"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIG9ZW2M/g/XfnyG2r574LbxL1IgoDdx8D0MqWdaoPFvpAAAABHNzaDo= jess@paimon"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQ3a+IP2KTH1LG/sLABJwYWtRGYgC891FiN9a5vJNRwZx8XnbweiBMFOBoRfPWie2lJ65KDJX0UU3pW2N2u7VshPlYHT9euWcu/LgEYb4AkAdumJyR31VZqvSwT41SDkYQ3S8a3TpQnlkpsXBOuvzYDymStvhrSMgo7+aLXbBAZKkVlGUq8A2HCoTb0TqN7UZArgEx+naHwv/Wc31hx6j2IifsRUQ/PDsvKD25ax8Ws9+3gH0W5qJAtMIoEcKqcban6ZR7mplOOJK2/sG13va1fXY1jyUcMUzqR4cK947yXgRMaFvh6o3t1BWBKBNYtG430W5+Ns3ahcCt3ic/IPfPUTtgKUlHMwSeJKQN4PzbExiXkCO5Ugxq9+if4kLwCKaTnlkQtC+7I8aVb7EIca8RaG6B2bwX9z7LjlTitTmAwC/UNtGCWGMwPaJI2KIqbnDdn7l9mQT0GUKZHEwAZ6x8s9tXRFEsoZpKBUmwHfdAQo6a78zWi9gUAZi7xi0UJVc= jess@paimon"
    ];
  };
}
