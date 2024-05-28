{ lib }:
{
  mkPresetConfigEnableOption = name: lib.mkEnableOption "preset configuration of ${name}";

  mkCatppuccinOption =
    name: hasAccent:
    {
      enable = lib.mkEnableOption "Catppuccin theme for ${name}" // {
        default = true;
      };
      flavor = lib.mkOption {
        default = "frappe";
        example = "mocha";
        description = "Catppuccin flavor for ${name}.";
        type = lib.types.flavorOption;
      };
    }
    // lib.optionalAttrs hasAccent {
      accent = lib.mkOption {
        default = "pink";
        example = "blue";
        description = "Catppuccin accent for ${name}.";
        type = lib.types.accentOption;
      };
    };
}
