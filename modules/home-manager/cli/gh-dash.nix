{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "gh-dash";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name true;
  };

  config.programs.gh-dash = mkIf enable (mkMerge [
    {
      enable = true;
      package = (
        pkgs.gh-dash.overrideAttrs (
          _: prev: {
            nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.makeWrapper ];
            postFixup = ''
              wrapProgram $out/bin/gh-dash --set LANG C.UTF-8
            '';
          }
        )
      );
    }

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        settings = importYAML "${ctp.sources.gh-dash}/themes/${flavor}/catppuccin-${flavor}-${accent}.yml";
      }
    ))
  ]);
}
