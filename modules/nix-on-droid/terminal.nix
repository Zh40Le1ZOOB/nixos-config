{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "terminal";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name false;
  };

  config.terminal = mkIf enable (mkMerge [
    { font = "${pkgs.fira-code-nerdfont}/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Regular.ttf"; }

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        colors = (
          builtins.mapAttrs (_: color: ctp.palette.${flavor}.colors.${color}.hex) {
            foreground = "text";
            background = "base";
            color0 = "surface1";
            color1 = "red";
            color2 = "green";
            color3 = "yellow";
            color4 = "blue";
            color5 = "pink";
            color6 = "teal";
            color7 = "subtext1";
            color8 = "surface2";
            color9 = "red";
            color10 = "green";
            color11 = "yellow";
            color12 = "blue";
            color13 = "pink";
            color14 = "teal";
            color15 = "subtext0";
          }
        );
      }
    ))
  ]);
}
