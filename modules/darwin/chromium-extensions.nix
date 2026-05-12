# Chromium-family browser policies for Homebrew-installed macOS browsers.
#
# Add Chrome Web Store extensions once in `registry`, then opt them into each
# browser under `browsers.<name>.extensions`.
{pkgs, ...}: let
  cwsUpdateUrl = "https://clients2.google.com/service/update2/crx";
  plist = pkgs.formats.plist {};

  registry = {
    "30-seconds-of-knowledge" = {
      id = "mmgplondnjekobonklacmemikcnhklla";
      name = "30 Seconds of Knowledge";
    };
    "7tv" = {
      id = "ammjkodgmmoknidbanneddgankgfejfh";
      name = "7TV";
    };
    adguard-adblocker = {
      id = "bgnkhhnnamicmpeenaelnjfhikgbkllg";
      name = "AdGuard AdBlocker";
    };
    amgiflol = {
      id = "kpkpcekkflbmmmhjlnkbkfkdjfjnnonl";
      name = "amgiflol";
    };
    better-ruler = {
      id = "ilcnadaaninblgbekoaihdhoiecaflie";
      name = "Better Ruler";
    };
    betterttv = {
      id = "ajopnjidmegmdimjlfnijceegpefgped";
      name = "BetterTTV";
    };
    bitwarden = {
      id = "nngceckbapebfimnlniiiahkandclblb";
      name = "Bitwarden Password Manager";
    };
    builtwith = {
      id = "dapjbgnjinbpoindlpdmhochffioedbn";
      name = "BuiltWith Technology Profiler";
    };
    canvas-blocker-fingerprint-protect = {
      id = "nomnklagbgmgghhjidfhnoelnjfndfpd";
      name = "Canvas Blocker - Fingerprint Protect";
    };
    darkreader = {
      id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
      name = "Dark Reader";
    };
    duckduckgo-privacy-essentials = {
      id = "bkdgflcldnnnapblkhphbgpggdiikppg";
      name = "DuckDuckGo Search & Tracker Protection";
    };
    form-troubleshooter = {
      id = "lpjhcgjbicfdoijennopbjooigfipfjh";
      name = "Form Troubleshooter";
    };
    frankerfacez = {
      id = "fadndhdgpmmaapbmfcknlfgcflmmmieb";
      name = "FrankerFaceZ";
    };
    google-docs-offline = {
      id = "ghbmnnjooekpmoecnnnilnnbdlolhkhi";
      name = "Google Docs Offline";
    };
    hackerrank-quickapply = {
      id = "mmlghgaenodejbokcogohcjelnogcckl";
      name = "HackerRank QuickApply";
    };
    measure-everything = {
      id = "accaohnljoiaebphephigghihhpeknff";
      name = "Measure Everything";
    };
    privacy-badger = {
      id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";
      name = "Privacy Badger";
    };
    react-devtools = {
      id = "fmkadmapgofadopljbjfkapdkoienihi";
      name = "React Developer Tools";
    };
    reduxdevtools = {
      id = "lmhkpmbekcpmknklioeibfkpmmfibljd";
      name = "Redux DevTools";
    };
    save-all-resources = {
      id = "abpdnfjocnmdomablahdcfnoggeeiedb";
      name = "Save All Resources";
    };
    screen-ruler = {
      id = "jfbbgijjljfbolelfkopkhbfjajjampm";
      name = "Screen Ruler - Measure and Inspect the Web";
    };
    supersorter = {
      id = "hjebfgojnlefhdgmomncgjglmdckngij";
      name = "SuperSorter";
    };
    svelte-devtools = {
      id = "kfidecgcdjjfpeckbblhmfkhmlgecoff";
      name = "Svelte DevTools";
    };
    tablerone = {
      id = "andpjllgocabfacjlelkfpdemfklpfpo";
      name = "TABLERONE tab manager";
    };
    toby = {
      id = "hddnkoipeenegfoeaoibdmnaalmgkpip";
      name = "Toby: Tab Management Tool";
    };
    unpaywall = {
      id = "iplffkdpngmdjhlpjmppncnlhomiipha";
      name = "Unpaywall";
    };
    videospeed = {
      id = "nffaoalbilbmmfgbnbgppjihopabppdk";
      name = "Video Speed Controller";
    };
    visbug = {
      id = "cdockenadnadldjbbgcallicgledbeoc";
      name = "VisBug";
    };
    vue-js-devtools = {
      id = "nhdogjmejiglipccpnnnanhbledajbpd";
      name = "Vue.js devtools";
    };
    youtube-auto-hd-fps = {
      id = "fcphghnknhkimeagdglkljinmpbagone";
      name = "YouTube Auto HD + FPS";
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
    "form-troubleshooter"
    "frankerfacez"
    "google-docs-offline"
    "hackerrank-quickapply"
    "measure-everything"
    "privacy-badger"
    "react-devtools"
    "reduxdevtools"
    "save-all-resources"
    "screen-ruler"
    "supersorter"
    "svelte-devtools"
    "tablerone"
    "toby"
    "unpaywall"
    "videospeed"
    "visbug"
    "vue-js-devtools"
    "youtube-auto-hd-fps"
  ];

  # Edit these lists to add/remove/update extensions per Chromium browser.
  browsers = {
    helium = {
      bundleId = "net.imput.helium";
      extensions = importedFromChrome;
      policies = {
        BrowserSignin = 0;
        DefaultBrowserSettingEnabled = false;
        MetricsReportingEnabled = false;
        PasswordManagerEnabled = false;
        SearchSuggestEnabled = false;
        SyncDisabled = true;
      };
    };
  };

  extensionForcelist = extensions:
    map (name: "${registry.${name}.id};${cwsUpdateUrl}") extensions;

  extensionSettings = extensions:
    builtins.listToAttrs (map (name: {
        name = registry.${name}.id;
        value = {
          installation_mode = "force_installed";
          update_url = cwsUpdateUrl;
        };
      })
      extensions);

  policyFor = browser:
    browsers.${browser}.policies
    // {
      ExtensionInstallForcelist = extensionForcelist browsers.${browser}.extensions;
      ExtensionSettings = extensionSettings browsers.${browser}.extensions;
    };

  heliumPolicy = plist.generate "helium-managed-policy.plist" (policyFor "helium");
in {
  system.activationScripts.heliumChromiumPolicies.text = ''
    echo >&2 "installing Helium managed policies..."
    install -d -m 0755 "/Library/Managed Preferences"
    install -m 0644 "${heliumPolicy}" "/Library/Managed Preferences/${browsers.helium.bundleId}.plist"
    chown root:wheel "/Library/Managed Preferences/${browsers.helium.bundleId}.plist"
  '';
}
