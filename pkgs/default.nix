{ pkgs, inputs }:
pkgs.extend (
  _: _: with pkgs; {
    lib = callPackage ../lib { inherit inputs; };
    rime-data = callPackage ./rime-data.nix { };
    inherit (callPackage ./minecraft-server.nix { }) buildQuiltMinecraftServer;
  }
)
