{lib, ...}: let
  # Config files managed by this repo but kept writable in $HOME.
  #
  # Use this for tools that edit their own config in place. Home Manager's
  # home.file/xdg.configFile would create Nix-store symlinks, which makes those
  # edits awkward or impossible.
  writableConfigFiles = [
    {
      target = ".config/jj/config.toml";
      source = ./jujutsu/config.toml;
    }
  ];

  installWritableConfig = {
    target,
    source,
  }: ''
    target_file="$HOME/${target}"
    source_file="${source}"

    mkdir -p "$(dirname "$target_file")"
    cp "$source_file" "$target_file"
    chmod u+w "$target_file"
  '';
in {
  home.activation.installWritableConfigFiles = lib.hm.dag.entryAfter ["writeBoundary"] (
    lib.concatMapStringsSep "\n" installWritableConfig writableConfigFiles
  );
}
