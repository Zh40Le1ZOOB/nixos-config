{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "grub";
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

  config.boot.loader.grub = mkIf enable (mkMerge [
    { enable = true; }

    (mkIf catppuccin.enable {
      splashImage = "${catppuccinPkg}/grub/background.png";
      theme = "${catppuccinPkg}/grub";
      font = "${catppuccinPkg}/grub/font.pf2";
    })
  ]);
}
