{ config, lib, ... }:
let
  name = "fzf";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name false;
  };

  config.programs.fzf = mkIf enable (mkMerge [
    {
      enable = true;
      enableFishIntegration = true;
    }

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        colors = (
          builtins.mapAttrs (_: color: ctp.palette.${flavor}.colors.${color}.hex) {
            fg = "text";
            bg = "base";
            hl = "red";
            "fg+" = "text";
            "bg+" = "surface0";
            "hl+" = "red";
            info = "mauve";
            prompt = "mauve";
            pointer = "rosewater";
            marker = "rosewater";
            spinner = "rosewater";
            header = "red";
          }
        );
      }
    ))
  ]);
}
