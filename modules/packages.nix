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
    catppuccin-catwalk
    curl
    dust
    eza
    fd
    # fish
    ffmpeg
    fnm
    hyperfine
    inputs.home-manager.packages.${pkgs.system}.home-manager
    moon
    scc
    nodePackages.typescript-language-server
    vim
    vivid # Color genratero for `ls` like commands
  ];
}
