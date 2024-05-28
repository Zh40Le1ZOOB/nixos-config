{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "fish";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name false;
  };

  config = mkIf enable (mkMerge [
    {
      programs.fish = {
        enable = true;
        package = pkgs.fish-unwrapped;
      };
    }

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        xdg.configFile."fish/themes".source = "${ctp.sources.fish}/themes";
        programs.fish.shellInit = ''
          fish_config theme choose "Catppuccin ${toUpper1 flavor}"
        '';
      }
    ))
  ]);
}
