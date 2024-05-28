{ config, lib, ... }:
let
  name = "openssh";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
in
with lib;
{
  options.presetConfig.${name}.enable = mkPresetConfigEnableOption name;

  config.services.openssh = mkIf enable {
    enable = true;
    settings.PermitRootLogin = "yes";
  };
}
