{
  description = "Nix config + Flakes + Home Manager";

  inputs = {
    # Nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    catppuccin = {
      url = "github:catppuccin/nix";
    };
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    nix-darwin,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    # Your custom packages and modifications, exported as overlays
    # overlays = import ./overlays {inherit inputs;};

    defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin;

    darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.yoda.imports = [./home-manager];
          # networking.hostName = hostName;
          home-manager.extraSpecialArgs = {inherit inputs;};
        }
        nix-homebrew.darwinModules.nix-homebrew
        # First time install
        # {
        #   nix-homebrew = {
        #     # Install Homebrew under the default prefix
        #     enable = true;

        #     # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
        #     enableRosetta = true;

        #     # User owning the Homebrew prefix
        #     user = "yoda";

        #     # Optional: Declarative tap management
        #     taps = {
        #       "homebrew/homebrew-bundle" = homebrew-bundle;
        #       "homebrew/homebrew-core" = homebrew-core;
        #       "homebrew/homebrew-cask" = homebrew-cask;
        #     };

        #     # Optional: Enable fully-declarative tap management
        #     #
        #     # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
        #     mutableTaps = false;
        #   };
        # }
        # Existing installation
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "yoda";

            # Automatically migrate existing Homebrew installations
            autoMigrate = true;
          };
        }
      ];
      specialArgs = {
        inherit self inputs;
      };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MacBook-Pro".pkgs;
  };
}
