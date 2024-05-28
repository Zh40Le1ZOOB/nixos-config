{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:Zh40Le1ZOOB/nixpkgs/fish";
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    catppuccin.url = "github:catppuccin/nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-on-droid,
      deploy-rs,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        super-pc-12400 = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          pkgs = import ./pkgs {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            inherit inputs;
          };
          inherit (pkgs) lib;
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./hosts/super-pc-12400 ];
        };
        electronic-waste = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          pkgs = import ./pkgs {
            pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
                nvidia.acceptLicense = true;
                permittedInsecurePackages = [ "openssl-1.1.1w" ];
              };
            };
            inherit inputs;
          };
          inherit (pkgs) lib;
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./hosts/electronic-waste ];
        };
        vinegar = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          pkgs = import ./pkgs {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            inherit inputs;
          };
          inherit (pkgs) lib;
          modules = [ ./hosts/vinegar ];
        };
        installer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./profiles/installer.nix ];
        };
      };
      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import ./pkgs {
          pkgs = import nixpkgs {
            system = "aarch64-linux";
            config.allowUnfree = true;
          };
          inherit inputs;
        };
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [ ./hosts/phone ];
      };

      packages.x86_64-linux.installer = self.nixosConfigurations.installer.config.system.build.isoImage;

      deploy.nodes.vinegar = {
        remoteBuild = true;
        sshUser = "root";
        hostname = "192.168.10.3";
        profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vinegar;
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
