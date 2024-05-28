{ config, lib, ... }:
let
  name = "hyfetch";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
in
with lib;
{
  options.presetConfig.${name}.enable = mkPresetConfigEnableOption name;

  config.programs.hyfetch = mkIf enable {
    enable = true;
    settings = {
      preset = "transgender";
      mode = "rgb";
      color_align.mode = "horizontal";
    };
  };
}
