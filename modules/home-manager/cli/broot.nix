{ config, lib, ... }:
let
  name = "broot";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
in
with lib;
{
  options.presetConfig.${name}.enable = mkPresetConfigEnableOption name;

  config.programs.broot = mkIf enable {
    enable = true;
    enableFishIntegration = true;
    settings = {
      default_flags = "--hidden";
      show_selection_mark = true;
      icon_theme = "nerdfont";
      special_paths = {
        ".git" = {
          list = "never";
          sum = "never";
        };
      };
    };
  };
}
