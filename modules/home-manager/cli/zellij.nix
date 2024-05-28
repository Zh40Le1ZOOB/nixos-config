{ config, lib, ... }:
let
  name = "zellij";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name false;
  };

  config.programs.zellij = mkIf enable (mkMerge [
    {
      enable = true;
      enableFishIntegration = true;
    }

    (mkIf catppuccin.enable (with catppuccin; { settings.theme = "catppuccin-${flavor}"; }))
  ]);
}
