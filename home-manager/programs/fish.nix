{lib, ...}: let
  aliases = import ./aliases.nix;
  shellAbbrs = builtins.mapAttrs (_: a: a.command) (
    lib.filterAttrs (_: b: !(b.fishAlias or false)) aliases
  );
  shellAliases = builtins.mapAttrs (_: a: a.command) (
    lib.filterAttrs (_: b: builtins.hasAttr "fishAlias" b && b.fishAlias) aliases
  );
in {
  programs.fish = {
    enable = true;
    catppuccin.enable = true;

    inherit shellAbbrs shellAliases;

    shellInit = ''
      for config in ${./fish/configs}/*.fish
        source "$config"
      end
    '';

    functions = {
      code = ''
        if test -d "$argv[1]" -o -f "$argv[1]"
            open -a "Visual Studio Code" "$argv[1]"
        else
            command code $argv
        end
      '';
    };
  };
}
