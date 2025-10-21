_: {
  programs.difftastic.git.enable = true;
  programs.git = {
    enable = true;

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
      user.email = "smitp.contact@gmail.com";
      user.name = "Smit";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
