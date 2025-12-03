{
  description = "Nix config + Flakes + Home Manager";

  inputs = {
    # Nixpkgs
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs/stable";

      # The main branch follows the "canary" channel of the Android SDK
      # repository. Use another android-nixpkgs branch to explicitly
      # track an SDK release channel.
      #
      # url = "github:tadfisher/android-nixpkgs/stable";
      # url = "github:tadfisher/android-nixpkgs/beta";
      # url = "github:tadfisher/android-nixpkgs/preview";
      # url = "github:tadfisher/android-nixpkgs/canary";
    };
    # If you have nixpkgs as an input, this will replace the "nixpkgs" input
    # for the "android" flake.
    android-nixpkgs.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin = {
      url = "github:catppuccin/nix";
    };
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rust-overlay = {
    #   url = "github:oxalica/rust-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    android-nixpkgs,
    catppuccin,
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

    # Define user configurations
    # https://github.com/AlexNabokikh/nix-config/blob/master/flake.nix
    users = {
      sakatagintoki = {
        # avatar = ./files/avatar/face;
        email = "smitp.contact@gmail.com";
        fullName = "Smit P";
        hostPlatform = "aarch64-darwin";
        hostName = "sakatagintoki";
        # gitKey = "C5810093";
        userName = "yoda";
      };
      hijikatatoshiro = {
        # avatar = ./files/avatar/face;
        email = "smitp.contact@gmail.com";
        fullName = "Smit P";
        hostPlatform = "aarch64-darwin";
        hostName = "hijikatatoshiro";
        # gitKey = "C5810093";
        userName = "yoda";
      };
    };

    mkNixosConfiguration = system: hostName: userName:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs hostName;
          userConfig = users.${userName};
          nixosModules = "${self}/modules/nixos";
        };
        modules = [./hosts/${hostName}];
      };

    # Function for nix-darwin system configuration
    mkDarwinConfiguration = user:
      nix-darwin.lib.darwinSystem {
        system = user.hostPlatform;
        specialArgs = {
          inherit self inputs;
          userConfig = user;
        };
        modules = [
          ./modules/darwin
          # ./hosts/${hostName}
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user.userName}.imports = [
              # TEMP android-nixpkgs.hmModule
              ./home-manager
            ];
            # networking.hostName = hostName;
            home-manager.extraSpecialArgs = {
              inherit self inputs;
              userConfig = user;
            };
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = user.userName;

              # Optional: Declarative tap management
              taps = {
                "homebrew/homebrew-bundle" = homebrew-bundle;
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };

              mutableTaps = false;
            };
          }
        ];
      };

    # Function for Home Manager configuration
    mkHomeConfiguration = system: userName: hostName:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        extraSpecialArgs = {
          inherit inputs outputs;
          userConfig = users.${userName};
          nhModules = "${self}/modules/home-manager";
        };
        modules = [
          ./home/${userName}/${hostName}
          catppuccin.homeModules.catppuccin
        ];
      };

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
    # Other options beside 'alejandra' include 'nixfmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      # kotarokatsura = mkNixosConfiguration "aarch64-linux" "kotarokatsura" "yoda";
    };

    darwinConfigurations = {
      "sakatagintoki" = mkDarwinConfiguration users.sakatagintoki;
      "hijikatatoshiro" = mkDarwinConfiguration users.hijikatatoshiro;
    };

    homeConfigurations = {
      # "yoda@sakatagintoki" = mkHomeConfiguration "aarch64-darwin" "nabokikh" "nabokikh-mac";
    };
  };
}
