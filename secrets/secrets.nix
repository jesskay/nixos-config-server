let
  userJessPaimon = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQ3a+IP2KTH1LG/sLABJwYWtRGYgC891FiN9a5vJNRwZx8XnbweiBMFOBoRfPWie2lJ65KDJX0UU3pW2N2u7VshPlYHT9euWcu/LgEYb4AkAdumJyR31VZqvSwT41SDkYQ3S8a3TpQnlkpsXBOuvzYDymStvhrSMgo7+aLXbBAZKkVlGUq8A2HCoTb0TqN7UZArgEx+naHwv/Wc31hx6j2IifsRUQ/PDsvKD25ax8Ws9+3gH0W5qJAtMIoEcKqcban6ZR7mplOOJK2/sG13va1fXY1jyUcMUzqR4cK947yXgRMaFvh6o3t1BWBKBNYtG430W5+Ns3ahcCt3ic/IPfPUTtgKUlHMwSeJKQN4PzbExiXkCO5Ugxq9+if4kLwCKaTnlkQtC+7I8aVb7EIca8RaG6B2bwX9z7LjlTitTmAwC/UNtGCWGMwPaJI2KIqbnDdn7l9mQT0GUKZHEwAZ6x8s9tXRFEsoZpKBUmwHfdAQo6a78zWi9gUAZi7xi0UJVc=";
  userJessRpi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINeU3BPOaB4nzPhDt4ZOG+oDk0FqjgjWWQIBtUKoYqQp";
  users = [ userJessPaimon userJessRpi ];

  sysRpi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFj7yhCk3WMYkPYtyTDhx8DRH42BUo3JbwYdT/kHLjZ";
  systems = [ sysRpi ];
in
{
  "munin-email.age".publicKeys = users ++ systems;
  "miniflux-admin.age".publicKeys = users ++ systems;
}
