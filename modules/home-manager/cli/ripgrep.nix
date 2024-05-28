{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "ripgrep";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
in
with lib;
{
  options.presetConfig.${name}.enable = mkPresetConfigEnableOption name;

  config = mkIf enable {
    home.packages = [ pkgs.ripgrep-all ];
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--hidden"
        "--glob=!.git/*"
      ];
    };
  };
}
