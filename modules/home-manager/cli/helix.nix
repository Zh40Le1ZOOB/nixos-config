{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "helix";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name false;
  };

  config.programs.helix = mkIf enable (mkMerge [
    {
      enable = true;
      defaultEditor = true;
      languages = {
        language-server.nil = {
          command = "${getExe pkgs.nil}";
          config.nil.formatting.command = [ "${getExe pkgs.nixfmt-rfc-style}" ];
        };
        language = [
          {
            name = "nix";
            language-servers = [ "nil" ];
          }
        ];
      };
    }

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        settings = {
          editor.color-modes = true;
          theme = "catppuccin-${flavor}";
        };
        themes."catppuccin-${flavor}" = importTOML "${ctp.sources.helix}/themes/default/catppuccin_${flavor}.toml";
      }
    ))
  ]);
}
