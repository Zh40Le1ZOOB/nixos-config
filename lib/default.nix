{
  lib,
  pkgs,
  inputs,
}:
lib.extend (
  final: prev: {
    trivial =
      prev.trivial
      // import ./trivial.nix {
        lib = final;
        inherit pkgs;
      };
    strings = prev.strings // import ./strings.nix { lib = final; };
    options = prev.options // import ./options.nix { lib = final; };
    types = prev.types // import ./types.nix { lib = final; };

    ctp = import ./catppuccin.nix {
      lib = final;
      inherit pkgs inputs;
    };

    inherit (final.trivial) importYAML;
    inherit (final.strings) toUpper1;
    inherit (final.options) mkPresetConfigEnableOption mkCatppuccinOption;
  }
)
