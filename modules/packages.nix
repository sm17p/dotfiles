{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.home-manager
    vim
    curl
    # pkgs.direnv
    # pkgs.age
    # pkgs.glow
    eza
    fish

    nodePackages.typescript-language-server

    fnm
    moon

    dust
    fd
    hyperfine
    catppuccin-catwalk
    vivid
  ];
}
