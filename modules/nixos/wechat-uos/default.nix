{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "wechat-uos";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
in
with lib;
{
  options.presetConfig.${name}.enable = mkPresetConfigEnableOption name;

  config.environment.systemPackages = optional enable (
    pkgs.wechat-uos.override { uosLicense = ./license.tar.gz; }
  );
}
