{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "sddm";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable enableWayland catppuccin;
  catppuccinPkgs =
    with pkgs;
    with catppuccin;
    [
      (catppuccin-sddm.override {
        flavor = flavor;
        loginBackground = true;
      })
      catppuccin-cursors."${flavor}${lib.toUpper1 accent}"
    ];
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    enableWayland = mkEnableOption "Wayland support for ${name}";
    catppuccin = mkCatppuccinOption name true;
  };

  config = mkIf enable (mkMerge [
    {
      services.displayManager.sddm = {
        enable = true;
        autoNumlock = true;
      };
    }

    (mkIf (!enableWayland) { services.xserver.enable = true; })

    (mkIf enableWayland { services.displayManager.sddm.wayland.enable = true; })

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        environment.systemPackages = catppuccinPkgs;
        services.displayManager.sddm = {
          theme = "catppuccin-${flavor}";
          settings.Theme.CursorTheme = "catppuccin-${flavor}-${accent}-cursors";
          setupScript = ''
            echo "Xcursor.theme: catppuccin-${flavor}-${accent}-cursors" | xrdb -nocpp -merge
          ''; # https://github.com/sddm/sddm/issues/1894#issuecomment-2041431779
        };
      }
    ))
  ]);
}
