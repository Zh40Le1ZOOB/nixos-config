{ inputs, ... }:
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit inputs;
    };
    config = {
      imports = import ../../modules/home-manager/module-list.nix;
      presetConfig = {
        atuin.enable = true;
        bat.enable = true;
        broot.enable = true;
        btop.enable = true;
        carapace.enable = true;
        eza.enable = true;
        fish.enable = true;
        fzf.enable = true;
        gh-dash.enable = true;
        gh.enable = true;
        git.enable = true;
        gitui.enable = true;
        helix.enable = true;
        hyfetch.enable = true;
        ripgrep.enable = true;
        scmpuff.enable = true;
        starship.enable = true;
        yazi.enable = true;
        zoxide.enable = true;
      };

      home.stateVersion = "24.05";
    };
  };
}
