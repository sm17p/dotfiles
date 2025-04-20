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
    eza
    fd
    go
    hoppscotch
    # fish
    just
    ffmpeg
    fnm
    hyperfine
    inputs.home-manager.packages.${pkgs.system}.home-manager
    lapce
    moon
    scc
    nodePackages.typescript-language-server
    vim
    vivid # Color genratero for `ls` like commands

    # Nix LSPs
    nil
    nixd
  ];
}
