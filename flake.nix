{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      mac-app-util,
      sops-nix,
      nixgl,
    }:
    let
      # pkgs = nixpkgs.legacyPackages.${system};
      allowed_unfree_packages = [
        "terraform"
        "vscode"
        "ngrok"
        "obsidian"
      ];

      buildInputs = {
        darwin = {
          system = "aarch64-darwin";
          user = "kristina.pianykh@goflink.com";
        };
        arch = {
          system = "x86_64-linux";
          user = "krispian";
        };
      };
      buildConf = builtins.mapAttrs (
        name:
        {
          system,
          user,
        }:
        {
          inherit system user;
          pkgs = import nixpkgs {
            inherit system;
            # overlays = [ nodeOverlay ];
            config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) allowed_unfree_packages;
          };
          pkgsUnstable = import nixpkgs-unstable { inherit system; };
        }
      ) buildInputs;
      homeManagerStateVersion = "24.11";
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#flink
      darwinConfigurations.flink =
        with buildConf.darwin;
        nix-darwin.lib.darwinSystem {
          modules = [
            ./configuration.nix
            mac-app-util.darwinModules.default
            home-manager.darwinModules.home-manager
            {
              users.users.${user}.home = "/Users/${user}";
              home-manager = {
                # useGlobalPkgs alows to use system instance on nixpkgs. By default, home-manager will create its own instance of nixpkgs
                # the unfree packages to use can't be defined on the home-manager level then anymore
                # details in thread: https://discourse.nixos.org/t/home-manager-does-not-allowunfree/25681/5
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user} = {
                  imports = [
                    mac-app-util.homeManagerModules.default
                    ./home-manager/darwin/default.nix
                  ];
                };
                # Optionally, use home-manager.extraSpecialArgs to pass
                # arguments to home.nix
                extraSpecialArgs = {
                  inherit
                    self
                    inputs
                    system
                    user
                    pkgs
                    pkgsUnstable
                    homeManagerStateVersion
                    ;
                };
              };
            }
            # We expose some extra arguments so that our modules can parameterize
            # better based on these values.
            # {
            #   config._module.args = {
            #     inherit inputs;
            #     currentSystem = system;
            #     currentSystemUser = user;
            #   };
            # }
          ];
          specialArgs = {
            inherit
              self
              inputs
              system
              user
              pkgsUnstable
              ; # pass pkgs as well?
          };
        };

      homeConfigurations = with buildConf.arch; {
        ${user} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            username = user;
            inherit inputs pkgsUnstable homeManagerStateVersion;
          };

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./home-manager/arch/default.nix
            sops-nix.homeManagerModules.sops
          ];
          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
      };
    };
}
