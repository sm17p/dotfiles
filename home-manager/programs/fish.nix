{...}: {
  programs.fish = {
    enable = true;

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
