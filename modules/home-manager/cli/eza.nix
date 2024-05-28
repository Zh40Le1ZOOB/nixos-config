{ config, lib, ... }:
let
  name = "eza";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
in
with lib;
{
  options.presetConfig.${name}.enable = mkPresetConfigEnableOption name;

  config.programs.eza = mkIf enable {
    enable = true;
    enableFishIntegration = true;
    extraOptions = [ "--all" ];
    icons = true;
    git = true;
  };
}
