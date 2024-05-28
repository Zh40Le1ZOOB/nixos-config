{
  pkgs,
  inputs,
  chafaFormat ? "sixel",
  ...
}:
let
  pkgs-fifc = import inputs.nixpkgs-fifc { system = pkgs.stdenv.hostPlatform.system; };
in
{
  imports = [
    ../../bat.nix
    ../../broot.nix
    ../../eza.nix
    ../../fzf.nix
    ../../ripgrep.nix
  ];
  home.packages = with pkgs; [
    pkgs-fifc.fishPlugins.fifc
    chafa
    fd
    hexyl
    procs
  ];
  programs.fish.interactiveShellInit = ''
    set -U fifc_chafa_opts --format=${chafaFormat}
    set -U fifc_fd_opts --hidden
  '';
}
