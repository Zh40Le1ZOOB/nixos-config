{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "bat";
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

  config.programs.bat = mkIf enable (mkMerge [
    {
      enable = true;
      config.style = "full";
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batgrep
        batman
        batpipe
        batwatch
      ];
    }

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        config.theme = "Catppuccin ${toUpper1 flavor}";
        themes."Catppuccin ${toUpper1 flavor}" = {
          src = "${catppuccinPkg}/bat";
          file = "Catppuccin ${toUpper1 flavor}.tmTheme";
        };
      }
    ))
  ]);
}
