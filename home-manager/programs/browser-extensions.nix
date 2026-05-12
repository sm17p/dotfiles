# Declarative Firefox-family extension registry.
#
# Add an extension once under `registry`, then opt it into each browser under
# `browsers`. We use AMO policy installs (`id` + `slug`) instead of profile
# side-loading packages so Firefox/Zen force-install and enable extensions on
# first launch.
{
  lib,
  pkgs,
}: let
  registry = {
    # Existing Firefox/Zen preferences.
    amgiflol = {
      id = "amgiflol@sm17p.me";
      slug = "amgiflol";
    };
    bonjourr-startpage = {
      id = "{4f391a9e-8717-4ba6-a5b1-488a34931fcb}";
      slug = "bonjourr-startpage";
    };
    clearurls = {
      id = "{74145f27-f039-47ce-a470-a662b129930a}";
      slug = "clearurls";
    };
    decentraleyes = {
      id = "jid1-BoFifL9Vbdl2zQ@jetpack";
      slug = "decentraleyes";
    };
    ghostery = {
      id = "firefox@ghostery.com";
      slug = "ghostery";
    };

    # Imported from Chrome where Firefox/Zen equivalents exist.
    "30-seconds-of-knowledge" = {
      id = "30secondsofknowledge@petrovicstefan.rs";
      slug = "30-seconds-of-knowledge";
    };
    "7tv" = {
      id = "moz-addon-prod@7tv.app";
      slug = "7tv-extension";
    };
    adguard-adblocker = {
      id = "adguardadblocker@adguard.com";
      slug = "adguard-adblocker";
    };
    better-ruler = {
      id = "{e120fb6c-5d5e-4f01-9515-a0b305dfb427}";
      slug = "better-ruler";
    };
    betterttv = {
      id = "firefox@betterttv.net";
      slug = "betterttv";
    };
    bitwarden = {
      id = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
      slug = "bitwarden-password-manager";
    };
    builtwith = {
      id = "gary@builtwith.com";
      slug = "builtwith";
    };
    canvas-blocker-fingerprint-protect = {
      id = "{e98b4b87-bc39-439f-a175-b15fbe4a06c0}";
      slug = "canvas-blocker-no-fingerprint";
    };
    darkreader = {
      id = "addon@darkreader.org";
      slug = "darkreader";
    };
    duckduckgo-privacy-essentials = {
      id = "jid1-ZAdIEUB7XOzOJw@jetpack";
      slug = "duckduckgo-for-firefox";
    };
    frankerfacez = {
      id = "frankerfacez@frankerfacez.com";
      slug = "frankerfacez";
    };
    measure-everything = {
      id = "{e1d11714-1c10-4d0c-b440-76336f4408be}";
      slug = "measure-everything";
    };
    privacy-badger = {
      id = "jid1-MnnxcxisBPnSXQ@jetpack";
      slug = "privacy-badger17";
    };
    react-devtools = {
      id = "@react-devtools";
      slug = "react-devtools";
    };
    reduxdevtools = {
      id = "extension@redux.devtools";
      slug = "reduxdevtools";
    };
    save-all-resources = {
      id = "{dcf76b6c-3ee2-4772-8c02-eb15d9838333}";
      slug = "save-all-resources";
    };
    screen-ruler = {
      # Closest AMO equivalent for Chrome's "Screen Ruler - Measure and Inspect the Web".
      id = "{220eb399-db43-4b4d-a3e2-92cb2349684d}";
      slug = "screensruler";
    };
    svelte-devtools = {
      id = "{a0370179-acc3-452f-9530-246b6adb2768}";
      slug = "svelte-devtools";
    };
    tab-session-manager = {
      id = "Tab-Session-Manager@sienori";
      slug = "tab-session-manager";
    };
    unpaywall = {
      id = "{f209234a-76f0-4735-9920-eb62507a54cd}";
      slug = "unpaywall";
    };
    videospeed = {
      id = "{7be2ba16-0f1e-4d93-9ebc-5164397477a9}";
      slug = "videospeed";
    };
    visbug = {
      id = "{50864413-c4c8-43b0-80b8-982c4a368ac9}";
      slug = "visbug";
    };
    vue-js-devtools = {
      id = "{5caff8cc-3d2e-4110-a88a-003cc85b3858}";
      slug = "vue-js-devtools";
    };
    youtube-auto-hd-fps = {
      id = "avi6106@gmail.com";
      slug = "youtube-auto-hd-fps";
    };
  };

  importedFromChrome = [
    "30-seconds-of-knowledge"
    "7tv"
    "adguard-adblocker"
    "amgiflol"
    "better-ruler"
    "betterttv"
    "bitwarden"
    "builtwith"
    "canvas-blocker-fingerprint-protect"
    "darkreader"
    "duckduckgo-privacy-essentials"
    "frankerfacez"
    "measure-everything"
    "privacy-badger"
    "react-devtools"
    "reduxdevtools"
    "save-all-resources"
    "screen-ruler"
    "svelte-devtools"
    "tab-session-manager"
    "unpaywall"
    "videospeed"
    "visbug"
    "vue-js-devtools"
    "youtube-auto-hd-fps"
  ];

  existingFirefox = [
    "bonjourr-startpage"
    "clearurls"
    "decentraleyes"
    "ghostery"
  ];

  # Edit these lists to add/remove/update extensions per browser.
  browsers = {
    firefox = existingFirefox ++ importedFromChrome;
    zen = existingFirefox ++ importedFromChrome;
  };

  # Chrome extensions that did not have a direct Firefox-family equivalent.
  # Keep these here as a checklist if you want to choose substitutes later.
  chromeOnlyOrUnmapped = [
    "Form Troubleshooter"
    "Google Docs Offline"
    "HackerRank QuickApply"
    "SuperSorter"
    "TABLERONE tab manager"
    "Toby: Tab Management Tool"
  ];

  selected = browser: lib.unique (browsers.${browser} or []);
  get = name: registry.${name};
  isPackage = name: (get name) ? package;
  isAmo = name: (get name) ? id && (get name) ? slug;

  mkAmoSetting = name: let
    extension = get name;
  in {
    name = extension.id;
    value = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${extension.slug}/latest.xpi";
      installation_mode = "force_installed";
    };
  };
in {
  inherit registry browsers chromeOnlyOrUnmapped;

  packagesFor = browser: map (name: (get name).package) (builtins.filter isPackage (selected browser));

  extensionSettingsFor = browser:
    builtins.listToAttrs (map mkAmoSetting (builtins.filter isAmo (selected browser)));
}
