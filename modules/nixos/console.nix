{ config, lib, ... }:
let
  name = "console";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name false;
  };

  config.console = mkIf enable (mkMerge [
    {
      enable = true;
      earlySetup = true;
    }

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        colors = map (color: (substring 1 6 ctp.palette.${flavor}.colors.${color}.hex)) [
          "base"
          "red"
          "green"
          "yellow"
          "blue"
          "pink"
          "teal"
          "subtext1"
          "surface2"
          "red"
          "green"
          "yellow"
          "blue"
          "pink"
          "teal"
          "subtext0"
        ];
      }
    ))
  ]);
}
