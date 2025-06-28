{
  config,
  inputs,
  lib,
  pkgs,
  self,
  userConfig,
  ...
}:
with lib; {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget

  # environment.etc."zshenv".text = mkBefore ''
  #     set -x
  # '';

  imports = [
    ../packages.nix
    ../services/ollama.nix
  ];

  ids.gids.nixbld = 350;

  environment.etc."fish/config.fish".text = mkBefore ''
    # set -gx PNPM_HOME "/Users/yoda/.local/share/pnpm"
    # set -gx PATH "$PNPM_HOME" $PATH
  '';

  fonts.packages = [
    pkgs.nerd-fonts._0xproto
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.iosevka-term
    pkgs.nerd-fonts.open-dyslexic
    pkgs.nerd-fonts.shure-tech-mono
  ];

  environment.shells = [
    pkgs.zsh
    pkgs.fish
  ];

  environment.variables = {
    ASTRO_TELEMETRY_DISABLED = "1";
    FNM_COREPACK_ENABLED = "true";
    FNM_RESOLVE_ENGINES = "true";
    HOMEBREW_NO_ANALYTICS = "1";
    HOMEBREW_NO_INSECURE_REDIRECT = "1";
    HOMEBREW_NO_EMOJI = "1";
  };

  # Homebrew needs to be installed on its own!
  homebrew = {
    brews = [
      "exercism"
      "pkgconf"
      "trash" # Delete files and folders to trash instead of rm
      "git-lfs" # Git LFS for large files
      "rustup"
    ];
    casks = [
      # "nushell"
      # "logitech-g-hub"
      "android-studio"
      "amethyst"
      "ferdium"
      "firefox"
      "marta"
      "signal"
      "brave-browser"
      "microsoft-edge"
      "discord"
      "visual-studio-code"
      # "wave"
      "google-chrome"
      "raycast"

      # "gitify" # Git notifications in menu bar
      "meetingbar" # Show meetings in menu bar
      "obsidian" # Obsidian packaging on Nix is not available for macOS
      "spotify"
      "rectangle"

      "vlc"

      # TODO:
      # SketchyBar status bar https://github.com/slano-ls/SketchyBar
    ];
    enable = true;
    onActivation = {
      autoUpdate = false; # Don't update during rebuild
      cleanup = "uninstall"; # Uninstall all programs not declared
      upgrade = true;
    };

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    masApps = {
      "slack" = 803453959;
      "surfshark" = 1437809329;
      "telegram" = 747648890;
    };

    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  home-manager.backupFileExtension = "backup";

  # Nix Settings
  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    allowed-users = [
      "yoda"
      "root"
    ];
    warn-dirty = false;
  };

  nix.optimise.automatic = true;

  nixpkgs = {
    hostPlatform = userConfig.hostPlatform;
    config = {
      android_sdk.accept_license = true;
      allowBroken = true;
      allowUnfree = true;
    };
    overlays = [inputs.android-nixpkgs.overlays.default];
  };

  programs = {
    fish = {
      enable = true;
    };
    zsh = {
      enable = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  # services.nix-daemon.enable = true;
  services.ollama = {
    enable = true;
    models = "/Users/yoda/.ollama/models/";
  };
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.defaults = {
    # controlcenter = {
    #   Bluetooth = true;
    # };
    # controlcenter.BatteryShowPercentage = true;
    # controlcenter.Bluetooth = true;
    # controlcenter.NowPlaying = true;
    # controlcenter.Sound = true;
    dock = {
      autohide = true;
      mru-spaces = false;
      orientation = "left";
    };
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.LoginwindowText = "yoda, I'm";
    screencapture.location = "~/Desktop/Screenshots";
    screensaver.askForPasswordDelay = 10;
  };
  system.primaryUser = "yoda";
  system.stateVersion = 4;

  users.knownUsers = ["yoda"];
  users.users = {
    yoda = {
      home = "/Users/yoda";
      shell = pkgs.fish;

      # dscl . list /groups
      # dscl . list /users
      # dscl
      # dscl . -read /Users/yoda UserShell
      # dscl . -read /Users/yoda UniqueID
      uid = 501; # 502 if secondary account on OS, 503 for tertiary and so forth... Mostly it's going to be 501 for a new device
    };
  };
}
