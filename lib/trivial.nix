{ lib, pkgs }:
{
  importYAML =
    path:
    lib.importJSON "${pkgs.runCommand "${baseNameOf path}-converted" { }
      "${lib.getExe pkgs.yj} < ${path} > $out"
    }";
}
