{ config, lib, ... }:
let
  name = "frp";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable;
in
with lib;
{
  options.presetConfig.${name}.enable = mkPresetConfigEnableOption name;

  config.services.frp = mkIf enable {
    enable = true;
    role = "client";
    settings = {
      user = "tasldx6y2qz8039o";
      serverAddr = "frp-bar.top";
      serverPort = 7000;
      loginFailExit = false;
      auth = {
        method = "token";
        token = "SakuraFrpClientToken";
      };
      transport = {
        protocol = "tcp";
        tcpMux = true;
        poolCount = 1;
        tls = {
          enable = true;
          disableCustomTLSFirstByte = true;
        };
      };
      proxies = [
        {
          name = "Minecraft";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 25565;
          remotePort = 49807;
        }
      ];
    };
  };
}
