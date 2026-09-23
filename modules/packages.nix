{
  pkgs,
  inputs,
  self,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # pkgs.age
    # pkgs.glow
    bandwhich # Terminal bandwidth utilization tool

    catppuccin-catwalk # Compose Catppuccin flavor screenshots into one preview
    cmake # Cross-platform build system generator
    curl # Transfer data with URLs

    delta # A viewer for git and diff output
    devenv # Declarative, reproducible developer environments
    dua # Tool to conveniently learn about the disk usage of directories
    dust # du + rust = dust. Like du but more intuitive
    self.packages.${pkgs.stdenv.hostPlatform.system}.exifcleaner # Strip EXIF and other metadata from images
    mkcert # Locally trusted TLS certificates for development
    eza # Modern replacement for `ls`
    fd # Simple, fast and user-friendly alternative to find
    ffmpeg # Record, convert, and stream audio and video
    go # Go compiler and toolchain
    hoppscotch # Open source API development ecosystem
    hyperfine # Command-line benchmarking tool
    inputs.herdr-nix.packages.${pkgs.stdenv.hostPlatform.system}.default # Terminal multiplexer that keeps coding-agent sessions alive
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager # Manage user environments and dotfiles with Nix
    jujutsu # Git-compatible DVCS
    llama-cpp # High-performance LLM inference
    just # Handy way to save and run project-specific commands
    # lapce # Lightning-fast and Powerful Code Editor written in Rust
    lefthook # Fast and powerful Git hooks manager for any type of projects
    neovim # Extensible Vim-based text editor
    typescript-language-server # Language server for TypeScript and JavaScript
    osv-scanner # Scan dependencies for known vulnerabilities
    pastel # Command-line tool to generate, analyze, convert and manipulate colors
    pdftk # Merge, split, and manipulate PDF files
    ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
    silicon # Create beautiful image of your source code
    scc # Very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go
    stripe-cli # Command-line client for the Stripe API
    vivid # Color generator for `ls` like commands
    # yaak # Desktop API client for organizing and executing REST, GraphQL, and gRPC requests
    inputs.zen-browser # Firefox-based browser with a vertical tab UI
    # Android
    # androidSdkPackages.cmdline-tools-latest # Provides adb, avdmanager, sdkmanager, etc.
    # androidSdkPackages.emulator           # Provides the Android emulator
    # You might also add specific build tools or platform tools if needed globally, e.g.:
    # androidSdkPackages.build-tools-35-0-0
    # androidSdkPackages.platform-tools
    # androidSdkPackages.platforms-android-35
    # androidSdkPackages.ndk-26-1-10909125           # Provides the Android emulator
    # androidSdkPackages.tools
    # zulu17

    # Nix
    alejandra # Opinionated Nix formatter
    nil # Incremental Nix language server
    nixd # Feature-rich Nix language server
  ];
}
