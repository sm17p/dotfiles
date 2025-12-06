{
  inputs,
  userConfig,
  ...
}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.zen-browser.homeModules.default
    ../programs/aliases.nix
    ../programs/vscode.nix
    ../programs/fish.nix
    ../programs/firefox.nix
    ../programs/git.nix
    ../programs/tealdeer.nix
  ];

  catppuccin = {
    bat.enable = true;
    fish.enable = true;
    zellij.enable = true;
  };

  home = {
    username = userConfig.userName;
    homeDirectory = "/Users/${userConfig.userName}";
    stateVersion = "24.05";
    shellAliases = {
      "l" = "eza -l -g --icons --git -a";
      "lt" = "eza --tree -g --level=2 --long --icons --git";
      "nix-rebuild" = "sudo darwin-rebuild switch --flake";
    };
  };

  programs = {
    alacritty.enable = true;
    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    bat.enable = true;
    carapace = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    home-manager.enable = true;
    bottom.enable = true;
    starship.enable = true;
    zellij = {
      enable = true;
      settings = {};
    };
    zen-browser = {
      enable = true;
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
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };

  systemd.user.startServices = "sd-switch";

  home.file.".wezterm.lua".text = ''
    return {
      color_scheme = "Catppuccin Mocha",
    }
  '';

  targets.darwin.linkApps = {
    enable = true;
    directory = "Applications/Home Manager Apps";
  };
}
