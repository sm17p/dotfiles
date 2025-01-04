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
    catppuccin-catwalk
    curl
    dust
    eza
    fd
    fish
    fnm
    hyperfine
    inputs.home-manager.packages.${pkgs.system}.home-manager
    moon
    nodePackages.typescript-language-server
    rustup
    vim
    vivid # Color genratero for `ls` like commands
  ];
}
