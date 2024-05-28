{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "gh";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
in
with lib;
{
  options.presetConfig.${name}.enable = mkPresetConfigEnableOption name;

  config.programs.gh = mkIf enable {
    enable = true;
    gitCredentialHelper.enable = true;
    extensions = [ pkgs.gh-f ];
  };
}
