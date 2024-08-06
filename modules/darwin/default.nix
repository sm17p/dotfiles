{
  pkgs,
  self,
  lib,
  ...
}:
with lib; {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget

  # environment.etc."zshenv".text = mkBefore ''
  #     set -x
  # '';

  # imports = [ <home-manager/nix-darwin> ];

  # environment.etc."fish/config.fish".text = mkBefore ''
  #     set fish_trace 2
  # '';

  environment.shells = [
    pkgs.zsh
    pkgs.fish
  ];

  environment.systemPackages = [
    pkgs.vim
    pkgs.curl
    # pkgs.direnv
    # pkgs.age
    # pkgs.glow
    pkgs.eza
    pkgs.fish
  ];

  # Homebrew needs to be installed on its own!
  homebrew.enable = true;
  homebrew.casks = [
    # "wireshark"
    # "google-chrome"
  ];
  homebrew.brews = [
    # "imagemagick"
  ];

  home-manager.backupFileExtension = "backup";

  # Nix Settings
  nix.configureBuildUsers = true;
  nix.useDaemon = true;
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
  nixpkgs.hostPlatform = "aarch64-darwin";

  programs = {
    fish = {
      enable = true;
    };
    zsh = {
      enable = true;
    };
  };

  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.LoginwindowText = "yoda, I'm";
    screencapture.location = "~/Desktop/Screenshots";
    screensaver.askForPasswordDelay = 10;
  };
  system.stateVersion = 4;

  users.knownUsers = ["yoda"];
  users.users = {
    yoda = {
      home = "/Users/yoda";
      shell = pkgs.fish;
      uid = 502;
    };
  };
}
