{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "fcitx5";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable enableWayland catppuccin;
  catppuccinPkg = pkgs.fcitx5-catppuccin;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    enableWayland = mkEnableOption "Wayland support for ${name}";
    catppuccin = mkCatppuccinOption name false;
  };

  config.i18n.inputMethod = mkIf enable (mkMerge [
    {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [ (fcitx5-rime.override { rimeDataPkgs = [ rime-data ]; }) ];
        settings.addons.classicui.globalSection."Vertical Candidate List" = true;
      };
    }

    (mkIf enableWayland { fcitx5.waylandFrontend = true; })

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        fcitx5 = {
          addons = [ catppuccinPkg ];
          settings.addons.classicui.globalSection.Theme = "catppuccin-${flavor}";
        };
      }
    ))
  ]);
}
