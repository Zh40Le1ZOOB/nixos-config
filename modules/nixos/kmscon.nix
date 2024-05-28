{ config, lib, ... }:
let
  name = "kmscon";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name false;
  };

  config.services.kmscon = mkIf enable (mkMerge [
    {
      enable = true;
      extraConfig = ''
        term = xterm-kitty
      '';
    }

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        extraConfig = with ctp.palette.${flavor}.colors; ''
          palette = custom
          palette-foreground = ${text.rgb}
          palette-background = ${base.rgb}
          palette-black = ${surface1.rgb}
          palette-red = ${red.rgb}
          palette-green = ${green.rgb}
          palette-yellow = ${yellow.rgb}
          palette-blue = ${blue.rgb}
          palette-magenta = ${pink.rgb}
          palette-cyan = ${teal.rgb}
          palette-light-grey = ${subtext1.rgb}
          palette-dark-grey = ${surface2.rgb}
          palette-light-red = ${red.rgb}
          palette-light-green = ${green.rgb}
          palette-light-yellow = ${yellow.rgb}
          palette-light-blue = ${blue.rgb}
          palette-light-magenta = ${pink.rgb}
          palette-light-cyan = ${teal.rgb}
          palette-white = ${subtext0.rgb}
        '';
      }
    ))
  ]);
}
