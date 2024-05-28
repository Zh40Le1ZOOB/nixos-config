{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "google-chrome";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
  convertFlavor =
    flavor:
    if (flavor == "latte") then
      "jhjnalhegpceacdhbplhnakmkdliaddd"
    else if (flavor == "frappe") then
      "olhelnoplefjdmncknfphenjclimckaf"
    else if (flavor == "macchiato") then
      "cmpdlhmnmjhihmcfnigoememnffkimlk"
    else if (flavor == "mocha") then
      "bkkmolkhemgaeaeggcmfbghljjjoofoh"
    else
      throw "Impossible!";
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name false;
  };

  config = mkIf enable (mkMerge [
    {
      environment.systemPackages = [ pkgs.google-chrome ];
      programs.chromium = {
        enable = true;
        enablePlasmaBrowserIntegration = true;
        extensions = [
          "cjpalhdlnbpafiamejdnhcphjbkeiagm"
          "dhdgffkkebhmkfjojejmpbldmpobfkfo"
        ];
      };
    }

    (mkIf catppuccin.enable (
      with catppuccin; { programs.chromium.extensions = [ (convertFlavor flavor) ]; }
    ))
  ]);
}
