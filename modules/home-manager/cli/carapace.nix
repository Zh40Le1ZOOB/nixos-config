{ config, lib, ... }:
let
  name = "carapace";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
in
with lib;
{
  options.presetConfig.${name}.enable = mkPresetConfigEnableOption name;

  config.programs.carapace = mkIf enable {
    enable = true;
    enableFishIntegration = true;
  };
}
