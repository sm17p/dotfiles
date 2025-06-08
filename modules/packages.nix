{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # pkgs.age
    # pkgs.direnv
    # pkgs.glow
    # rectangle # Tiling Manager
    # vlc # Video Player
    # zed-editor
    # ollama
    bun
    catppuccin-catwalk
    curl
    cmake
    dust
    deno
    devenv
    direnv
    eza
    fd
    go
    # gitbutler
    hoppscotch
    # fish
    just
    jujutsu # Git-compatible DVCS
    firefox-devedition
    ffmpeg
    fnm
    hyperfine
    inputs.home-manager.packages.${pkgs.system}.home-manager
    lapce
    moon
    scc
    nodePackages.typescript-language-server
    neovim
    vivid # Color genratero for `ls` like commands

    # Android
    # androidSdkPackages.cmdline-tools-latest # Provides adb, avdmanager, sdkmanager, etc.
    # androidSdkPackages.emulator           # Provides the Android emulator
    # You might also add specific build tools or platform tools if needed globally, e.g.:
    # androidSdkPackages.build-tools-35-0-0
    # androidSdkPackages.platform-tools
    # androidSdkPackages.platforms-android-35
    # androidSdkPackages.ndk-26-1-10909125           # Provides the Android emulator
    # androidSdkPackages.tools
    watchman
    # zulu17

    # Nix LSPs
    nil
    nixd
  ];
}
