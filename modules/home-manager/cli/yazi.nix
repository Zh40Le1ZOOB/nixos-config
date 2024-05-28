{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "yazi";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name false;
  };

  config = mkIf enable (mkMerge [
    {
      home.packages = with pkgs; [
        fd
        ffmpegthumbnailer
        file
        fzf
        jq
        poppler
        ripgrep
        unar
        zoxide
      ];
      programs.yazi = {
        enable = true;
        enableFishIntegration = true;
        settings.manager = {
          show_hidden = true;
          show_symlink = true;
        };
      };
    }

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        xdg.configFile."yazi/Catppuccin-${flavor}.tmTheme".source = "${ctp.sources.bat}/themes/Catppuccin ${toUpper1 flavor}.tmTheme";
        programs.yazi.theme = importTOML "${ctp.sources.yazi}/themes/${flavor}.toml";
      }
    ))
  ]);
}
