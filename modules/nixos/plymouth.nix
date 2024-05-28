{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "plymouth";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
  catppuccinPkg = pkgs.catppuccin-plymouth.override { variant = "frappe"; };
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name false;
  };

  config.boot.plymouth = mkIf enable (mkMerge [
    { enable = true; }

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        themePackages = [ catppuccinPkg ];
        theme = "catppuccin-${flavor}";
      }
    ))
  ]);
}
