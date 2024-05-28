{ config, lib, ... }:
let
  name = "atuin";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
in
with lib;
{
  options.presetConfig.${name}.enable = mkPresetConfigEnableOption name;

  config.programs.atuin = mkIf enable {
    enable = true;
    enableFishIntegration = true;
    settings.show_preview = true;
  };
}
