{
  lib,
  pkgs,
  inputs,
}:
{
  sources = import "${inputs.catppuccin}/.sources";

  palette = builtins.mapAttrs (
    name: value:
    value
    // {
      colors = builtins.mapAttrs (
        name: value:
        value
        // {
          rgb = builtins.concatStringsSep "," (
            map (x: toString x) (
              with value.rgb;
              [
                r
                g
                b
              ]
            )
          );
        }
      ) value.colors;
    }
  ) (lib.importJSON "${lib.ctp.sources.palette}/palette.json");
}
