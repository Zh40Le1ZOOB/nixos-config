{ config, lib, ... }:
let
  name = "git";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
  delta = {
    name = "delta";
    cfg = cfg.${delta.name};
    inherit (delta.cfg) enable catppuccin;
  };
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    ${delta.name} = with delta; {
      enable = mkPresetConfigEnableOption name // {
        default = true;
      };
      catppuccin = mkCatppuccinOption name false;
    };
  };

  config.programs.git = mkIf enable (mkMerge [
    {
      enable = true;
      userName = "command_block";
      userEmail = "mtf@ik.me";
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = "*";
      };

      lfs.enable = true;
    }

    (mkIf delta.enable (mkMerge [
      {
        delta = {
          enable = true;
          options.line-numbers = true;
        };
      }

      (mkIf delta.catppuccin.enable (
        with delta.catppuccin;
        {
          includes = [ { path = "${ctp.sources.delta}/catppuccin.gitconfig"; } ];
          delta.options.features = "catppuccin-${flavor}";
        }
      ))
    ]))
  ]);
}
