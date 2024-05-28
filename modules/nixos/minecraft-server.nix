{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "minecraft-server";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
in
with lib;
{
  options.presetConfig.${name}.enable = mkPresetConfigEnableOption name;

  config.services.minecraft-server = mkIf enable {
    enable = true;
    declarative = true;
    eula = true;
    serverProperties = {
      accepts-transfers = false;
      allow-flight = true;
      allow-nether = true;
      broadcast-console-to-ops = true;
      broadcast-rcon-to-ops = true;
      bug-report-link = "";
      difficulty = "hard";
      enable-command-block = true;
      enable-jmx-monitoring = false;
      enable-query = false;
      enable-rcon = false;
      enable-status = true;
      enforce-secure-profile = true;
      enforce-whitelist = false;
      entity-broadcast-range-percentage = 100;
      force-gamemode = false;
      function-permission-level = 2;
      gamemode = "survival";
      generate-structures = true;
      generator-settings = "{}";
      hardcore = false;
      hide-online-players = false;
      initial-disabled-packs = "";
      initial-enabled-packs = "vanilla";
      level-name = "world";
      level-seed = "";
      level-type = "minecraft\:normal";
      log-ips = true;
      max-chained-neighbor-updates = 1000000;
      max-players = 20;
      max-tick-time = 120000;
      max-world-size = 29999984;
      motd = "command_block's Minecraft server！（Powered by Potatoes）";
      network-compression-threshold = 256;
      online-mode = false;
      op-permission-level = 4;
      player-idle-timeout = 0;
      prevent-proxy-connections = false;
      pvp = true;
      "query.port" = 25565;
      rate-limit = 0;
      "rcon.password" = "";
      "rcon.port" = 25575;
      region-file-compression = "deflate";
      require-resource-pack = false;
      resource-pack = "";
      resource-pack-id = "";
      resource-pack-prompt = "";
      resource-pack-sha1 = "";
      server-ip = "";
      server-port = 25565;
      simulation-distance = 10;
      spawn-animals = true;
      spawn-monsters = true;
      spawn-npcs = true;
      spawn-protection = 0;
      sync-chunk-writes = true;
      text-filtering-config = "";
      use-native-transport = true;
      view-distance = 10;
      white-list = false;
    };
    package = pkgs.buildQuiltMinecraftServer {
      minecraftVersion = "1.21";
      quiltVersion = "0.26.0";
      hash = "sha256-Nf8xECfJEpwugX5U3ARV8Fi/c+3IgKuaPvRpk4rtN30=";
    };
    jvmOpts = "-Xmx24G -Xms24G";
  };
}
