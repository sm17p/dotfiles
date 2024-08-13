{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.home-manager
    vim
    curl
    moon
    # pkgs.direnv
    # pkgs.age
    # pkgs.glow
    eza
    fish

    fnm

    dust
    fd
    hyperfine
    catppuccin-catwalk
    vivid
  ];
}
