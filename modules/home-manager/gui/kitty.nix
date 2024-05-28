{ config, lib, ... }:
let
  name = "kitty";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name false;
  };

  config.programs.kitty = mkIf enable (mkMerge [
    { enable = true; }

    (mkIf catppuccin.enable (with catppuccin; { theme = "Catppuccin-${toUpper1 flavor}"; }))
  ]);
}
