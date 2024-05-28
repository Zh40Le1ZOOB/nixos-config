{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "starship";
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

  config.programs.starship = mkIf enable (mkMerge [
    {
      enable = true;
      enableFishIntegration = true;
      settings.character = {
        success_symbol = "[](fg:black bg:#5BCEFA)[](fg:#5BCEFA bg:#F5A9B8)[](fg:#F5A9B8 bg:#FFFFFF)[](fg:#FFFFFF bg:#F5A9B8)[](fg:#F5A9B8 bg:#5BCEFA)[](#5BCEFA)";
        error_symbol = "[](fg:black bg:red)[](fg:red bg:red)[](red)";
      };
      enableTransience = true;
    }

    (mkIf catppuccin.enable (
      with catppuccin;
      ({
        settings = {
          palette = "catppuccin_${flavor}";
        } // importTOML "${catppuccinPkg}/starship/${flavor}.toml";
      })
    ))
  ]);
}
