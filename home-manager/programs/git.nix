_: {
  programs.git = {
    enable = true;
    difftastic.enable = true;

    ignores = [
      ".DS_Store"
    ];

    extraConfig = {
      diff.algorithm = "histogram";
      init.defaultBranch = "main";
      log.date = "iso";
      merge.conflictstyle = "zdiff3";
      push.autoSetupRemote = true;
    };

    userEmail = "smitp.contact@gmail.com";
    userName = "Smit";
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
