{
  inputs,
  lib,
  userConfig,
  ...
}: {
  imports =
    [
      inputs.zen-browser.homeModules.default
      ../programs/firefox.nix
      ../programs/vscode.nix
      ../programs/zen-browser.nix
    ]
    ++ lib.optionals (lib.hasSuffix "-linux" userConfig.hostPlatform) [
      inputs.helium-browser.homeModules.default
      ../programs/helium.nix
    ];

  programs.alacritty.enable = true;

  home.file.".wezterm.lua".text = ''
    return {
      color_scheme = "Catppuccin Mocha",
    }
  '';
}
