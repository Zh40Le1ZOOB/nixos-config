{ pkgs, ... }:
{
  imports = (import ../../modules/nixos/module-list.nix) ++ [ ./hardware-configuration.nix ];
  presetConfig = {
    openssh.enable = true;
    minecraft-server.enable = true;
    frp.enable = true;
  };
  boot.loader.systemd-boot.enable = true;
  zramSwap.enable = true;
  time.timeZone = "Asia/Shanghai";
  networking.hostName = "vinegar";
  environment.systemPackages = with pkgs; [
    helix
    git
  ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFLnI0RYtqVfY/4SETcr5F0iEFFzxVaSJDHVENaHoIvw Zh40Le1ZOOB@electronic-waste"
  ];

  nix.settings = {
    auto-optimise-store = true;
    substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store/" ];
    trusted-users = [ "root" ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  system.stateVersion = "24.11";
}
