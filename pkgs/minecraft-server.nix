{
  lib,
  stdenv,
  fetchurl,
  jre_headless,
  makeWrapper,
  udev,
}:
{
  buildQuiltMinecraftServer =
    {
      minecraftVersion ? "",
      quiltVersion ? "",
      hash ? "",
      quiltArgs ? { },
      ...
    }@args:
    stdenv.mkDerivation (
      args
      // {
        pname = "minecraft-server";
        version = "${minecraftVersion}-quilt-${quiltVersion}";

        src =
          let
            hash_ =
              if hash != "" then
                { outputHash = hash; }
              else
                {
                  outputHash = "";
                  outputHashAlgo = "sha256";
                };
          in
          stdenv.mkDerivation (
            quiltArgs
            // {
              pname = "quilt";
              version = "${quiltVersion}-minecraft-${minecraftVersion}";

              src = fetchurl {
                url = "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/0.9.2/quilt-installer-0.9.2.jar";
                hash = "sha256-w60+I+7oYOUYXFlOfLKA5Pq+fnZqg5RTgdmpnGSFXFs=";
              };

              dontUnpack = true;

              installPhase = ''
                ${lib.getExe jre_headless} -jar $src install server ${minecraftVersion} ${quiltVersion} --download-server --install-dir=$out
              '';

              outputHashMode = "recursive";
            }
            // hash_
          );

        nativeBuildInputs = [ makeWrapper ];

        installPhase = ''
          mkdir -p $out/lib/minecraft/
          cp -r $src/* $out/lib/minecraft/
          makeWrapper ${lib.getExe jre_headless} $out/bin/minecraft-server \
            --append-flags "-Dloader.gameJarPath=$out/lib/minecraft/server.jar -jar $out/lib/minecraft/quilt-server-launch.jar nogui" \
            --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]}
        '';
      }
    );
}
