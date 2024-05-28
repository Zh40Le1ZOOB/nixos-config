{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "scmpuff";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
in
with lib;
{
  options.presetConfig.${name}.enable = mkPresetConfigEnableOption name;

  config = mkIf enable {
    home.packages = with pkgs; [
      gawk
      which
    ];
    programs.scmpuff = {
      enable = true;
      enableFishIntegration = true;
      enableAliases = true;
    };
  };
}
