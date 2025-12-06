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

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
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
    nix4vscode,
    ...
  } @ inputs: let
    inherit (self) outputs;

    users = {
      sakatagintoki = {
        email = "smitp.contact@gmail.com";
        fullName = "Smit P";
        hostPlatform = "aarch64-darwin";
        hostName = "sakatagintoki";
        userName = "yoda";
      };
      hijikatatoshiro = {
        email = "smitp.contact@gmail.com";
        fullName = "Smit P";
        hostPlatform = "aarch64-darwin";
        hostName = "hijikatatoshiro";
        userName = "yoda";
      };
    };

    hosts = {
      sakatagintoki = {
        type = "darwin";
        system = users.sakatagintoki.hostPlatform;
        user = users.sakatagintoki;
        modulesPath = ./hosts/darwin/sakatagintoki;
        profiles = ["common" "darwin-common" "workstation"];
      };
      hijikatatoshiro = {
        type = "darwin";
        system = users.hijikatatoshiro.hostPlatform;
        user = users.hijikatatoshiro;
        modulesPath = ./hosts/darwin/hijikatatoshiro;
        profiles = ["common" "darwin-common" "workstation"];
      };
    };

    darwinHosts = nixpkgs.lib.filterAttrs (_: h: h.type == "darwin") hosts;
    nixosHosts = nixpkgs.lib.filterAttrs (_: h: h.type == "nixos") hosts;

    mkNixosConfiguration = hostName: host:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs hostName;
          userConfig = host.user;
          nixosModules = "${self}/modules/nixos";
        };
        modules = [
          ./modules/shared
          ./modules/nixos
          host.modulesPath
        ];
      };

    mkDarwinConfiguration = hostName: host:
      nix-darwin.lib.darwinSystem {
        system = host.system;
        specialArgs = {
          inherit self inputs hostName;
          userConfig = host.user;
        };
        modules = [
          ./modules/shared
          ./modules/darwin
          host.modulesPath
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${host.user.userName}.imports = [
              ./home-manager
            ] ++ (map (profile: ./home-manager/profiles/${profile}.nix) host.profiles);
            home-manager.extraSpecialArgs = {
              inherit self inputs;
              userConfig = host.user;
              hostName = hostName;
              hostProfiles = host.profiles;
            };
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = host.user.userName;
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

    darwinConfigurations = builtins.mapAttrs mkDarwinConfiguration darwinHosts;
    nixosConfigurations = builtins.mapAttrs mkNixosConfiguration nixosHosts;
    # Example: add a darwin host
    # darwinConfigurations.example-mac = mkDarwinConfiguration "example-mac" {
    #   type = "darwin";
    #   system = "aarch64-darwin";
    #   user = users.sakatagintoki;
    #   modulesPath = ./hosts/darwin/example-mac;
    #   profiles = ["common" "workstation"];
    # };
    # Example: add a nixos host
    # nixosConfigurations.kotarokatsura = mkNixosConfiguration "kotarokatsura" {
    #   type = "nixos";
    #   system = "aarch64-linux";
    #   user = users.yoda;
    #   modulesPath = ./hosts/nixos/kotarokatsura;
    #   profiles = ["common" "server"];
    # };

    homeConfigurations = {};
  };
}
