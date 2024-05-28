{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  name = "plasma";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
  catppuccinPkgs =
    with pkgs;
    with catppuccin;
    [
      (catppuccin-kde.override ({
        flavour = [ flavor ];
        accents = [ accent ];
        winDecStyles = [ "classic" ];
      }))
      catppuccin-cursors."${flavor}${lib.toUpper1 accent}"
    ];
in
with lib;
{
  imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name true;
  };

  config = mkIf enable (mkMerge [
    {
      programs.plasma = {
        enable = true;
        configFile = {
          dolphinrc = {
            ContentDisplay = {
              UsePermissionsFormat = "CombinedFormat";
            };
            General = {
              BrowseThroughArchives = true;
              FilterBar = true;
              RememberOpenedTabs = false;
              ShowFullPath = true;
              ShowFullPathInTitlebar = true;
              ShowToolTips = true;
              UseTabForSwitchingSplitView = true;
            };
          };
          kcminputrc.Keyboard.NumLock = 0;
          krunnerrc.General.FreeFloating = true;
          plasma-localerc.Formats.LANG = "zh_CN.UTF-8";
          plasmashellrc."Notification Messages".klipperClearHistoryAskAgain = false;
        };
        overrideConfig = true;
        workspace = {
          clickItemTo = "select";
          wallpaper = "${pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-simple-dark-gray.png";
            hash = "sha256-JaLHdBxwrphKVherDVe5fgh+3zqUtpcwuNbjwrBlAok=";
          }}";
        };
        panels = [
          {
            height = 44;
            location = "bottom";
            floating = true;
            widgets = [
              {
                name = "org.kde.plasma.kickoff";
                config.General = {
                  icon = "nix-snowflake-white";
                  favorites = [
                    "google-chrome.desktop"
                    "code.desktop"
                    "kitty.desktop"
                    "org.kde.dolphin.desktop"
                    "io.github.tdesktop_x64.TDesktop.desktop"
                    "qq.desktop"
                    "youtube-music.desktop"
                    "listen1.desktop"
                    "org.prismlauncher.PrismLauncher.desktop"
                    "steam.desktop"
                  ];
                };
              }
              "org.kde.plasma.pager"
              {
                name = "org.kde.plasma.icontasks";
                config.General.launchers = [
                  "applications:google-chrome.desktop"
                  "applications:code.desktop"
                  "applications:kitty.desktop"
                ];
              }
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.systemtray"
              "org.kde.plasma.digitalclock"
              "org.kde.plasma.showdesktop"
            ];
          }
        ];
      };
    }

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        home.packages = catppuccinPkgs;
        programs.plasma.workspace = {
          colorScheme = "Catppuccin${toUpper1 flavor}${toUpper1 accent}";
          cursor = {
            theme = "catppuccin-${flavor}-${accent}-cursors";
            size = 24;
          };
          lookAndFeel = "Catppuccin-${toUpper1 flavor}-${toUpper1 accent}";
        };
      }
    ))
  ]);
}
