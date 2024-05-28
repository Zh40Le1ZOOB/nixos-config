{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  name = "vscode";
  cfg = config.presetConfig.${name};
  inherit (cfg) enable catppuccin;
  inherit (inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system})
    vscode-marketplace
    ;
  catppuccinPkg = vscode-marketplace.catppuccin.catppuccin-vsc-pack;
  convertFlavor = flavor: if (flavor == "frappe") then "Frappé" else lib.toUpper1 flavor;
in
with lib;
{
  options.presetConfig.${name} = {
    enable = mkPresetConfigEnableOption name;
    catppuccin = mkCatppuccinOption name true;
  };

  config.programs.vscode = mkIf enable (mkMerge [
    {
      enable = true;
      package = pkgs.vscode.override { commandLineArgs = "--locale=zh-CN"; };
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      userSettings = {
        "diffEditor.experimental.showMoves" = true;
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.fontFamily" = "'FiraCode Nerd Font Mono', 'monospace', monospace";
        "editor.guides.bracketPairs" = "active";
        "editor.mouseWheelZoom" = true;
        "editor.smoothScrolling" = true;
        "files.trimFinalNewlines" = true;
        "files.trimTrailingWhitespace" = true;
        "workbench.list.horizontalScrolling" = true;
        "workbench.list.smoothScrolling" = true;

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${getExe pkgs.nil}";
        "nix.serverSettings.nil.formatting.command" = [ "${getExe pkgs.nixfmt-rfc-style}" ];
      };
      extensions = with vscode-marketplace; [
        adpyke.codesnap
        eamodio.gitlens
        jannisx11.batch-rename-extension
        jnoortheen.nix-ide
        ms-ceintl.vscode-language-pack-zh-hans
        naumovs.color-highlight
        yzhang.markdown-all-in-one
      ];
      mutableExtensionsDir = true;
    }

    (mkIf catppuccin.enable (
      with catppuccin;
      {
        userSettings = {
          "workbench.colorTheme" = "Catppuccin ${convertFlavor flavor}";
          "workbench.iconTheme" = "catppuccin-${flavor}";
        };
        extensions = [ catppuccinPkg ];
      }
    ))
  ]);
}
