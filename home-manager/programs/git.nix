{userConfig, ...}: {
  programs.difftastic.git.enable = true;
  programs.git = {
    enable = true;
    signing.format = "openpgp";

    ignores = [
      ".DS_Store"
      "/playwright-report/"
      "/playwright/.cache/"
    ];

    settings = {
      diff.algorithm = "histogram";
      init.defaultBranch = "main";
      log.date = "iso";
      merge.conflictstyle = "zdiff3";
      push.autoSetupRemote = true;
      user.email = userConfig.email;
      user.name = userConfig.fullName;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
