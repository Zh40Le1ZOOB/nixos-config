{ config, lib, ... }:
let
  name = "zoxide";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
in
with lib;
{
  options.presetConfig.${name}.enable = mkPresetConfigEnableOption name;

  config.programs.zoxide = mkIf enable {
    enable = true;
    enableFishIntegration = true;
  };
}
