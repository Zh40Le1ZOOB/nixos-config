{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fishPlugins.done
    libnotify
  ];
}
