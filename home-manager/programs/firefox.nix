{
  pkgs,
  lib,
  ...
}: let
  privacy = import ./browser-privacy.nix {inherit lib;};
  extensions = import ./browser-extensions.nix {inherit lib pkgs;};
in {
  programs.firefox = {
    enable = true;
    package = null;
    policies =
      privacy.policies
      // {
        ExtensionSettings = extensions.extensionSettingsFor "firefox";
      };

    profiles.sm17p = {
      id = 0;
      isDefault = true;
      path = "sm17p";

      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
        order = ["ddg" "google"];
        engines = {
          bing.metaData.hidden = true;
        };
      };

      bookmarks = {};

      extensions = {
        force = true;
        packages = extensions.packagesFor "firefox";
      };

      settings =
        privacy.settings
        // {
          "browser.uiCustomization.state" = builtins.toJSON {
            currentVersion = 20;
            newElementCount = 5;
            dirtyAreaCache = ["nav-bar" "PersonalToolbar" "toolbar-menubar" "TabsToolbar" "widget-overflow-fixed-list"];
            placements = {
              PersonalToolbar = ["personal-bookmarks"];
              TabsToolbar = ["tabbrowser-tabs" "new-tab-button" "alltabs-button"];
              nav-bar = ["back-button" "forward-button" "stop-reload-button" "urlbar-container" "downloads-button" "ublock0_raymondhill_net-browser-action" "_testpilot-containers-browser-action" "reset-pbm-toolbar-button" "unified-extensions-button"];
              toolbar-menubar = ["menubar-items"];
              unified-extensions-area = [];
              widget-overflow-fixed-list = [];
            };
            seen = ["save-to-pocket-button" "developer-button" "ublock0_raymondhill_net-browser-action" "_testpilot-containers-browser-action"];
          };
        };
    };
  };

  # Keep macOS Firefox's install-specific profile lock in sync with the
  # declarative Home Manager profile. Without this, Firefox may ignore
  # profiles.ini on startup and try to open an old or missing install profile.
  home.file."Library/Application Support/Firefox/installs.ini".text = ''
    [2656FF1E876E9973]
    Default=Profiles/sm17p
    Locked=1
  '';

  # xdg.mimeApps.defaultApplications = {
  #   "text/html" = ["firefox.desktop"];
  #   "text/xml" = ["firefox.desktop"];
  #   "x-scheme-handler/http" = ["firefox.desktop"];
  #   "x-scheme-handler/https" = ["firefox.desktop"];
  # };
}
