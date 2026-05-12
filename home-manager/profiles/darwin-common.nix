{pkgs, ...}: {
  home = {
    packages = [
      (pkgs.writeShellScriptBin "agent" ''
        exec /opt/homebrew/bin/cursor-agent "$@"
      '')
    ];

    shellAliases = {
      dig = "doggo";
      nix-rebuild = "sudo darwin-rebuild switch --flake";
    };
  };

  targets.darwin.linkApps = {
    enable = true;
    directory = "Applications/Home Manager Apps";
  };
}
