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
    # fish
    bandwhich # Terminal bandwidth utilization tool
    bun
    catppuccin-catwalk
    cmake
    curl
    deno
    devenv
    direnv
    dua # Tool to conveniently learn about the disk usage of directories
    dust # du + rust = dust. Like du but more intuitive
    eza
    fd # Simple, fast and user-friendly alternative to find
    ffmpeg
    firefox-devedition
    fnm
    go
    hoppscotch # Open source API development ecosystem
    hyperfine # Command-line benchmarking tool
    inputs.home-manager.packages.${pkgs.system}.home-manager
    jujutsu # Git-compatible DVCS
    just
    lapce # Lightning-fast and Powerful Code Editor written in Rust
    moon
    neovim
    nodePackages.typescript-language-server
    pastel # Command-line tool to generate, analyze, convert and manipulate colors
    ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
    silicon # Create beautiful image of your source code
    scc # Very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go
    tailscale # Node agent for Tailscale, a mesh VPN built on WireGuard
    vivid # Color genratero for `ls` like commands
    yaak # Desktop API client for organizing and executing REST, GraphQL, and gRPC requests
    # inputs.zen-browser
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
