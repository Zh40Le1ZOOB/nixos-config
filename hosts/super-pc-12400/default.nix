{ pkgs, ... }:
{
  imports = (import ../../modules/nixos/module-list.nix) ++ [
    ./hardware-configuration.nix
    ./home.nix
  ];
  presetConfig = {
    console.enable = true;
    fcitx5 = {
      enable = true;
      enableWayland = true;
    };
    fonts.enable = true;
    google-chrome.enable = true;
    grub.enable = true;
    kmscon.enable = true;
    openssh.enable = true;
    plasma = {
      enable = true;
      enableWayland = true;
    };
    plymouth.enable = true;
    sddm = {
      enable = true;
      enableWayland = true;
    };
  };
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  zramSwap.enable = true;
  hardware.pulseaudio.enable = true;
  time = {
    timeZone = "Asia/Shanghai";
    hardwareClockInLocalTime = true;
  };
  i18n.defaultLocale = "zh_CN.UTF-8";
  networking = {
    hostName = "super-pc-12400";
    networkmanager.enable = true;
    proxy.default = "http://127.0.0.1:7897";
  };
  programs = {
    fish = {
      enable = true;
      useBabelfish = true;
      plugins = with pkgs.fishPlugins; [
        autopair
        fifc
        done
      ];
    };
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
    steam.enable = true;
  };
  environment.systemPackages = with pkgs; [
    helix
    git
    kitty
    vlc
    libreoffice
    gimp
    clash-verge-rev
    _64gram
    qq
    youtube-music
    listen1
    prismlauncher
    deploy-rs
  ];
  users.users.Zh40Le1ZOOB = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store/"
        "https://cosmic.cachix.org/"
      ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
      trusted-users = [
        "root"
        "Zh40Le1ZOOB"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  system.stateVersion = "24.11";
}
