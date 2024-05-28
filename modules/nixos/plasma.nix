{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "plasma";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable enableWayland;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    enableWayland = mkEnableOption "Wayland support for ${name}";
  };

  config = mkIf enable (mkMerge [
    {
      services.desktopManager.plasma6.enable = true;
      environment.plasma6.excludePackages = with pkgs; [
        kate
        konsole
      ];
    }

    (mkIf (!enableWayland) { services.displayManager.defaultSession = "plasmax11"; })

    (mkIf enableWayland {
      services.displayManager = {
        defaultSession = "plasma";
        sddm.wayland.compositor = "kwin";
      };
    })
  ]);
}
