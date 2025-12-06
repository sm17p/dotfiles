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
  ids.gids.nixbld = 350;

  fonts.packages = [
    pkgs.nerd-fonts._0xproto
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.iosevka-term
    pkgs.nerd-fonts.open-dyslexic
    pkgs.nerd-fonts.shure-tech-mono
  ];

  # Homebrew needs to be installed on its own!
  homebrew = {
    brews = [
      "awscli"
      "exercism"
      "pkgconf"
      "ruby-build"
      "trash" # Delete files and folders to trash instead of rm
      "git-lfs" # Git LFS for large files
      "nss"
      "rustup"
      "postgresql"
      # GRD
      "mysql@8.0"
      "percona-toolkit"
      "imagemagick"
      "libvips"
      "libsodium"
    ];
    casks = [
      "alacritty"
      "brave-browser"
      "cursor"
      "discord"
      "docker-desktop"
      "firefox"
      "google-chrome"
      "lm-studio"
      "marta"
      "microsoft-edge"
      "raycast"
      "rectangle"
      "signal"
      "spotify"
      "steam"
      "vlc"
      "wezterm"
      "zed"
      # "amethyst"
      # "android-studio"
      # "ferdium"
      # "firefox-developer-edition"
      # "gitify" # Git notifications in menu bar
      # "handbrake-app"
      # "logitech-g-hub"
      # "losslesscut"
      # "meetingbar" # Show meetings in menu bar
      # "obsidian" # Obsidian packaging on Nix is not available for macOS
      # "visual-studio-code"
      # SketchyBar status bar https://github.com/slano-ls/SketchyBar
      # TODO:
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
      slack = 803453959;
      surfshark = 1437809329;
      telegram = 747648890;
    };

    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  # services.nix-daemon.enable = true;

  system.defaults = {
    controlcenter = {
      BatteryShowPercentage = true;
      Bluetooth = true;
      NowPlaying = true;
      Sound = true;
    };
    dock = {
      autohide = true;
      enable-spring-load-actions-on-all-items = true;
      magnification = false;
      mru-spaces = false;
      orientation = "left";
      persistent-apps = [
        {app = "/Applications/Cursor.app";}
        {app = "/Users/${userConfig.userName}/Applications/Home Manager Apps/Visual Studio Code.app";}
        {app = "/Applications/Zed.app";}
        {app = "/Applications/Google Chrome.app";}
        {app = "/Applications/Firefox.app";}
        # {app = "/Applications/Firefox Developer Edition.app";}
        {app = "/Applications/Microsoft Edge.app";}
        {app = "/Users/${userConfig.userName}/Applications/Home Manager Apps/Zen Browser (Beta).app";}
        {app = "/Applications/LM Studio.app";}
        {app = "/Applications/Docker.app";}
        {app = "/Applications/Alacritty.app";}
        {app = "/Applications/WezTerm.app";}
        {app = "/System/Applications/Music.app";}
        {app = "/Applications/Spotify.app";}
      ];
    };
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.LoginwindowText = "yoda, I'm";
    screencapture.location = "~/Desktop/Screenshots";
    screensaver.askForPasswordDelay = 10;
  };

  system.primaryUser = userConfig.userName;
  system.stateVersion = 4;

  users.knownUsers = [userConfig.userName];
  users.users = {
    ${userConfig.userName} = {
      home = "/Users/${userConfig.userName}";
      shell = pkgs.fish;
      uid = 501;
    };
  };
}
