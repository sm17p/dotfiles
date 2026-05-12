# Secrets

Secrets are managed with `sops-nix` and encrypted with age recipients derived from SSH public keys.

- System secrets: `secrets/<host>.yaml`, decrypted by the host SSH key at `/etc/ssh/ssh_host_ed25519_key`.
- Home Manager secrets: `secrets/<host>/<user>.yaml`, decrypted by a restored user SSH key.
- `.sops.yaml` controls which public recipients can decrypt each file.

New-machine bootstrap:

1. Restore your chosen SOPS SSH private/public key pair from your password manager or backup.
2. Restrict the private key permissions.
3. Set `SOPS_USER_KEY` to the restored private key path. Set `SOPS_USER_PUBKEY` too if needed.
4. Run `make sops-user-recipient` and confirm it matches `.sops.yaml`.
5. Run `make sops-verify` before rebuilding.

Useful commands:

```sh
# Derive an age recipient from a host SSH public key
make sops-host-recipient

# Derive an age recipient from the portable user SSH public key
make sops-user-recipient

# Verify all committed secret files decrypt with the portable user key
make sops-verify

# Edit encrypted system secrets for the current host
make sops-edit-system

# Edit encrypted Home Manager secrets for the current user/host
make sops-edit-home
```

Never commit decrypted scratch files. Commit only SOPS-encrypted files.
