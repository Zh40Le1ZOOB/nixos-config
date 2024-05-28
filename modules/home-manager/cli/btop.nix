{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "btop";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
  catppuccinPkg = pkgs.catppuccin.override ({ variant = catppuccin.flavor; });
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name false;
  };

  config = mkIf enable (mkMerge [
    { programs.btop.enable = true; }

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        xdg.configFile."btop/themes".source = "${catppuccinPkg}/btop";
        programs.btop.settings.color_theme = "catppuccin_${flavor}.theme";
      }
    ))
  ]);
}
