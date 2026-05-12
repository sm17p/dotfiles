# Nix flake for macOS (nix-darwin) and NixOS

Cross-platform flake with Home Manager profiles, shared modules, and per-host overrides.

## Quick start
- Prereqs: Nix with flakes enabled (`export NIX_CONFIG="experimental-features = nix-command flakes"`).
- Clone: `git clone https://github.com/sm17p/dotfiles`.
- macOS apply: `darwin-rebuild switch --flake .#sakatagintoki` (or `.#hijikatatoshiro`).
- NixOS apply: `sudo nixos-rebuild switch --flake .#<nixos-host>`.

## Bootstrap with make
- `make bootstrap-mac` — installs Nix, then nix-darwin using `FLAKE` (defaults to `.#$(hostname -s)`).
- `make darwin-rebuild` — rebuilds nix-darwin with the current `FLAKE`.
- Override host: `make darwin-rebuild FLAKE=.#sakatagintoki`.
- Other helpers: `make flake-update`, `make flake-update-homebrew`, `make flake-check`, `make nix-gc`, `make home-manager-switch`, `make sops-edit-system`, `make sops-edit-home`.

## Layout
- `flake.nix`: inputs, host registry, shared builders for nix-darwin, NixOS, and standalone Home Manager.
- `hosts/`: per-host settings  
  - `darwin/<host>/default.nix`  
  - `nixos/<host>/{hardware-configuration.nix,default.nix}`
- `modules/shared`: cross-platform settings (nix config, shells, common pkgs, SOPS tooling).
- `modules/secrets.nix`: optional per-host SOPS defaults.
- `modules/darwin`: macOS-specific settings split between core defaults and Homebrew bundles.
- `modules/nixos`: Linux-specific (placeholder; add boot/fs/impermanence here).
- `home-manager/default.nix`: base Home Manager identity, state version, and optional home-level SOPS defaults.
- `home-manager/profiles`: reusable stacks (`common`, `darwin-common`, `workstation`, `server`).
- `home-manager/programs`: HM modules (browser privacy, fish, firefox, git, tealdeer, VS Code, Zen).
- `pkgs/`, `overlays/`: custom packages and overlays.
- `secrets/`: SOPS-encrypted host and user secrets. Only encrypted files should be committed.
- `.agents/skills/`: canonical repo-tracked Agent Skills for cross-tool reuse.

## Agent skills

This repo keeps portable Agent Skills in `.agents/skills/`. That directory is
the source of truth for the skill content, but it is not itself a discovery path
for every client. Each tool still needs the skills linked or installed into its
own native location.

Current skills:
- `jj-commit`: writes a multi-line `jj describe` message for an explicit revset.
- `jj-push`: creates or moves a bookmark and pushes it to `origin`.

Manual hookup examples:
- Codex: `ln -s "$PWD/.agents/skills/jj-commit" ~/.codex/skills/jj-commit` and
  `ln -s "$PWD/.agents/skills/jj-push" ~/.codex/skills/jj-push`
- Claude Code: `ln -s "$PWD/.agents/skills/jj-commit" ~/.claude/skills/jj-commit`
  and `ln -s "$PWD/.agents/skills/jj-push" ~/.claude/skills/jj-push`
- Gemini CLI: `gemini skills link "$PWD/.agents/skills/jj-commit"` and
  `gemini skills link "$PWD/.agents/skills/jj-push"`

Gemini also supports installing or linking skills through its native skills
commands. Codex and Claude pick them up from their own skill directories after
the link or copy is in place.

## Adding a host
1) Add host metadata in `flake.nix` under `hosts` with `type` (`darwin`/`nixos`), `system`, `user`, `modulesPath`, and `profiles`.
2) Create `hosts/<platform>/<host>/default.nix` (and `hardware-configuration.nix` for NixOS).
3) Rebuild with `darwin-rebuild switch --flake .#<host>` or `nixos-rebuild switch --flake .#<host>`.

## Home Manager profiles
- Profiles live in `home-manager/profiles`. Each host lists profiles in `flake.nix`, e.g. `["common" "darwin-common" "workstation"]`.
- `common` includes cross-platform shell/tooling (fish, starship, zoxide, atuin, carapace), aliases, catppuccin theme, and CLI defaults.
- `darwin-common` contains macOS-only Home Manager settings such as app linking and Homebrew-backed aliases.
- `workstation` contains GUI/editor/browser Home Manager config.
- `server` is a stub for future headless defaults.

## Browser privacy and extensions
Firefox and Zen Browser share the same hardened Firefox-family preferences from `home-manager/programs/browser-privacy.nix`. Zen uses `programs.zen-browser.profiles.default.settings`, as supported by `0xc000022070/zen-browser-flake`, so the same telemetry, new-tab, password prompt, and HTTPS-only tightening applies there too.

Firefox-family extensions are managed from `home-manager/programs/browser-extensions.nix`:
- add an extension once in `registry`
- include it per browser in `browsers.firefox` or `browsers.zen`
- prefer NUR packages when available, or use AMO `id` + `slug` for policy-installed latest XPI

Helium Browser is also declared:
- macOS installs the Homebrew cask `helium-browser`
- Linux hosts can use `oxcl/nix-flake-helium-browser` through the Home Manager/NixOS modules, with default privacy-oriented Chromium policies in `home-manager/programs/helium.nix`

## Common tasks
- Rebuild macOS: `darwin-rebuild switch --flake .#<host>`.
- Rebuild NixOS: `sudo nixos-rebuild switch --flake .#<host>`.
- Switch Home Manager only: `home-manager switch --flake .#<user>@<host>`.
- Update inputs: `nix flake update`.
- Update Homebrew safely: `make flake-update-homebrew`.
- Edit system secrets: `make sops-edit-system`.
- Edit home secrets: `make sops-edit-home`.
- Verify secrets decrypt: `make sops-verify`.

## Secrets
This repo uses `sops-nix` with age recipients derived from SSH public keys, similar to the referenced dotfiles pattern.

The reliable new-machine model is: encrypted secrets are copied by Git, and only one private user identity has to be restored from your password manager or backup.

1. Restore your chosen SOPS SSH private/public key pair on the new machine and restrict the private key permissions.
2. Set `SOPS_USER_KEY` to the restored private key path. Set `SOPS_USER_PUBKEY` too if the public key is not at `SOPS_USER_KEY.pub`.
3. Clone this repo and run `make sops-user-recipient`; it should match the expected user recipient in `.sops.yaml`.
4. Run `make sops-verify` to prove the restored key decrypts committed secrets.
5. Rebuild with `make darwin-rebuild` or `make home-manager-switch`.
6. If the new machine needs system-level secrets, run `make sops-host-recipient`, add that public recipient to `.sops.yaml`, then run `sops updatekeys secrets/<host>.yaml` from a machine that can already decrypt.

- System secrets live at `secrets/<host>.yaml` and are decrypted unattended with `/etc/ssh/ssh_host_ed25519_key` after the host recipient is enrolled.
- Home Manager secrets live at `secrets/<host>/<user>.yaml` and are decrypted with a restored user SSH key.
- Public recipients are listed in `.sops.yaml`; private keys never belong in this repo.
- Keep the user recipient on every secret file as your recovery path.

## Troubleshooting
- Attribute renames: if `pkgs.system` warnings appear, use `pkgs.stdenv.hostPlatform.system`.
- Package renames: on macOS use `docker-desktop` instead of `docker`.
- If a profile change doesn’t load, ensure the host’s `profiles` list in `flake.nix` includes it.
- If `darwin-rebuild` fails during `brew bundle` with unreadable cask or DSL/arity errors, refresh `brew-src`, `nix-homebrew`, `homebrew-bundle`, `homebrew-core`, and `homebrew-cask` together instead of editing individual casks.
