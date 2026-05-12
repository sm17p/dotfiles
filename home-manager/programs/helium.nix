# Linux-only Helium Browser configuration. macOS installs Helium via Homebrew.
{...}: {
  programs.helium = {
    enable = true;

    flags = [
      "--enable-features=TouchpadOverscrollHistoryNavigation"
      "--ozone-platform-hint=auto"
      "--start-maximized"
    ];

    policies = {
      BrowserSignin = 0;
      DefaultBrowserSettingEnabled = false;
      MetricsReportingEnabled = false;
      PasswordManagerEnabled = false;
      SearchSuggestEnabled = false;
      SyncDisabled = true;
    };
  };
}
