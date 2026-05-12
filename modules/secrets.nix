# System-level SOPS defaults. Encrypted files are optional per host.
{
  lib,
  pkgs,
  hostName,
  ...
}: let
  systemSecretsFile = ../secrets + "/${hostName}.yaml";
in {
  environment.systemPackages = with pkgs; [
    age
    sops
    ssh-to-age
  ];

  sops = lib.mkIf (builtins.pathExists systemSecretsFile) {
    defaultSopsFile = systemSecretsFile;
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
