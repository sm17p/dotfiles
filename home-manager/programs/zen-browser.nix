{
  lib,
  pkgs,
  ...
}: let
  privacy = import ./browser-privacy.nix {inherit lib;};
  extensions = import ./browser-extensions.nix {inherit lib pkgs;};
in {
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    policies =
      privacy.policies
      // {
        ExtensionSettings = extensions.extensionSettingsFor "zen";
      };

    profiles.default = {
      id = 0;
      isDefault = true;
      path = "default";

      extensions.packages = extensions.packagesFor "zen";

      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
        order = ["ddg" "google"];
        engines = {
          bing.metaData.hidden = true;
        };
      };

      settings =
        privacy.settings
        // {
          "zen.welcome-screen.seen" = true;
          "zen.workspaces.continue-where-left-off" = true;
          "zen.urlbar.behavior" = "float";
        };
    };
  };

  # Zen, like Firefox, keeps install-specific default profiles in installs.ini.
  # Point all known Zen app install hashes at the declarative profile so startup
  # does not fall back to old generated profiles.
  home.file."Library/Application Support/Zen/installs.ini".text = ''
    [A63691297E687233]
    Default=Profiles/default
    Locked=1

    [C6181402110E1D04]
    Default=Profiles/default
    Locked=1

    [92D6F075B049FE64]
    Default=Profiles/default
    Locked=1

    [9FE932608B093EF5]
    Default=Profiles/default
    Locked=1
  '';
}
