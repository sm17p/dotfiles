# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  # android-nixpkgs,
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  system,
  userConfig,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    inputs.catppuccin.homeModules.catppuccin
    inputs.zen-browser.homeModules.default
    ./programs/aliases.nix
    ./programs/fish.nix
    ./programs/firefox.nix
    ./programs/git.nix
    ./programs/tealdeer.nix
  ];

  # android-sdk.enable = true;
  # # # Optional; default path is "~/.local/share/android".
  # android-sdk.path = "${config.home.homeDirectory}/.android/sdk";
  # android-sdk.packages = sdk:
  #   with sdk; [
  #     build-tools-35-0-0
  #     build-tools-34-0-0
  #     cmdline-tools-latest
  #     # emulator
  #     platform-tools
  #     platforms-android-35
  #     # sources-android-35
  #     ndk-27-2-12479018    # Provides the Android emulator
  #     tools
  # ];

  catppuccin = {
    bat.enable = true;
    fish.enable = true;
    zellij.enable = true;
  };

  home = {
    username = userConfig.userName;
    homeDirectory = "/Users/${userConfig.userName}";
  };

  # Enable home-manager and git
  programs = {
    alacritty = {
      enable = true;
    };

    # Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines
    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };

    bat = {
      enable = true;
    };

    # Multi-shell multi-command argument completer
    carapace = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };

    home-manager = {
      enable = true;
    };

    bottom = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    zellij = {
      enable = true;
      settings = {
        # theme =
        #   if pkgs.system == "aarch64-darwin"
        #   then "dracula"
        #   else "default";
        # # https://github.com/nix-community/home-manager/issues/3854
        # themes.dracula = {
        #   fg = [248 248 242];
        #   bg = [40 42 54];
        #   black = [0 0 0];
        #   red = [255 85 85];
        #   green = [80 250 123];
        #   yellow = [241 250 140];
        #   blue = [98 114 164];
        #   magenta = [255 121 198];
        #   cyan = [139 233 253];
        #   white = [255 255 255];
        #   orange = [255 184 108];
        # };
      };
    };

    zen-browser = {
      enable = false;
      # nativeMessagingHosts = [pkgs.firefoxpwa];
      policies = {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        ExtensionSettings = {
          "amgiflol@sm17p.me" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/amgiflol/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };

    # A smarter cd command. Supports all major shells.
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  home.shellAliases = {
    "l" = "eza -l -g --icons --git -a";
    "lt" = "eza --tree -g --level=2 --long --icons --git";
    "nix-rebuild" = "sudo darwin-rebuild switch --flake";
  };
}
