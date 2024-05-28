{ config, lib, ... }:
let
  name = "gitui";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name false;
  };

  config.programs.gitui = mkIf enable (mkMerge [
    { enable = true; }

    (mkIf catppuccin.enable (
      with catppuccin; { theme = readFile "${ctp.sources.gitui}/themes/catppuccin-${flavor}.ron"; }
    ))
  ]);
}
