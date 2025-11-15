# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    # Disable tests for fish - pexpect Python module is missing in nixpkgs-unstable
    # The error is in the test suite (missing pexpect dependency), not the actual binary
    # fish = prev.fish.overrideAttrs (oldAttrs: {
    #   doCheck = false;
    # });

    # Disable tests for cachix - it fails with nix 2.31.2 due to symbol mismatch
    # The error is in the test suite, not the actual binary, so disabling tests is safe
    # cachix = prev.cachix.overrideAttrs (oldAttrs: {
    #   doCheck = false;
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  # Note: Currently disabled since nixpkgs is already pointing to unstable
  # unstable-packages = final: _prev: {
  #   unstable = import inputs.nixpkgs-unstable {
  #     system = final.system;
  #     config.allowUnfree = true;
  #   };
  # };
}
