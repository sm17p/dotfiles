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
    dust
    deno
    devenv
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

    # Nix LSPs
    nil
    nixd
  ];
}
