{ pkgs, ... }:
{
  imports = (import ../../modules/nix-on-droid/module-list.nix) ++ [ ./home.nix ];
  presetConfig.terminal.enable = true;
  time.timeZone = "Asia/Shanghai";
  user.shell = "${pkgs.fish}/bin/fish";
  environment = {
    packages = with pkgs; [
      ncurses
      openssh
    ];
    motd = null;
    sessionVariables.LANG = "zh_CN.UTF-8";
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    max-jobs = auto
  '';
  system.stateVersion = "24.05";
}
