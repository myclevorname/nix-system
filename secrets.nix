{ lib, configName, ... }:
{
  services.openssh.authorizedKeysFiles = [ "/etc/secrets/ssh_key" ];
}
