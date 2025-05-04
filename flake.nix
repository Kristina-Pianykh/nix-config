{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    mac-app-util,
    nixgl,
  }: let
    system = "aarch64-darwin";
    # pkgs = nixpkgs.legacyPackages.${system};
    allowed_unfree_packages = [
      "terraform"
      "vscode"
    ];

    # workaround for the issue: https://github.com/NixOS/nixpkgs/issues/402079
    nodeOverlay = final: prev: {
      nodejs = prev.nodejs_22;
      nodejs-slim = prev.nodejs-slim_22;

      nodejs_20 = prev.nodejs_22;
      nodejs-slim_20 = prev.nodejs-slim_22;
    };

    pkgs = import nixpkgs {
      inherit system;
      overlays = [nodeOverlay];
      config.allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) allowed_unfree_packages;
    };
    user = "kristina.pianykh@goflink.com";
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#flink
    darwinConfigurations.flink = nix-darwin.lib.darwinSystem {
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
                ./home-manager/home.nix
              ];
            };
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            extraSpecialArgs = {
              inherit self inputs pkgs system user;
            };
          };
        }
        # We expose some extra arguments so that our modules can parameterize
        # better based on these values.
        {
          config._module.args = {
            currentSystem = system;
            currentSystemUser = user;
            inputs = inputs;
          };
        }
      ];
      specialArgs = {
        inherit self inputs system user;
      };
    };
  };
}
