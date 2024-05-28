{ modulesPath, ... }:
{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFLnI0RYtqVfY/4SETcr5F0iEFFzxVaSJDHVENaHoIvw Zh40Le1ZOOB@electronic-waste"
  ];
}
