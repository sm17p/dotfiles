# Nix flake for macOS (nix-darwin) and NixOS

Cross-platform flake with Home Manager profiles, shared modules, and per-host overrides.

## Quick start
- Prereqs: Nix with flakes enabled (`export NIX_CONFIG="experimental-features = nix-command flakes"`).
- Clone: `git clone https://github.com/sm17p/dotfiles`.
- macOS apply: `darwin-rebuild switch --flake .#sakatagintoki` (or `.#hijikatatoshiro`).
- NixOS apply: `sudo nixos-rebuild switch --flake .#<nixos-host>`.

## Bootstrap with make
- `make bootstrap-mac` — installs Nix, then nix-darwin using `FLAKE` (defaults to `.#$(hostname)`).
- `make darwin-rebuild` — rebuilds nix-darwin with the current `FLAKE`.
- Override host: `make darwin-rebuild FLAKE=.#sakatagintoki`.
- Other helpers: `make flake-update`, `make flake-check`, `make nix-gc`, `make home-manager-switch`.

## Layout
- `flake.nix`: inputs, hosts map, mkHost dispatcher.
- `hosts/`: per-host settings  
  - `darwin/<host>/default.nix`  
  - `nixos/<host>/{hardware-configuration.nix,default.nix}`
- `modules/shared`: cross-platform settings (nix config, shells, common pkgs).
- `modules/darwin`: macOS-specific (fonts, homebrew, touch ID).
- `modules/nixos`: Linux-specific (placeholder; add boot/fs/impermanence here).
- `home-manager/profiles`: reusable stacks (`common`, `workstation`, `server`).
- `home-manager/programs`: HM modules (aliases, fish, firefox, git, tealdeer).
- `pkgs/`, `overlays/`: custom packages and overlays.

## Adding a host
1) Add host metadata in `flake.nix` under `hosts` with `type` (`darwin`/`nixos`), `system`, `user`, `modulesPath`, and `profiles`.
2) Create `hosts/<platform>/<host>/default.nix` (and `hardware-configuration.nix` for NixOS).
3) Rebuild with `darwin-rebuild switch --flake .#<host>` or `nixos-rebuild switch --flake .#<host>`.

## Home Manager profiles
- Profiles live in `home-manager/profiles`. Each host lists profiles in `flake.nix`, e.g. `["common" "workstation"]`.
- `common` includes shell/tooling (fish, starship, zoxide, atuin, carapace), aliases, catppuccin theme, and defaults.
- `workstation` and `server` are stubs to extend for GUI/headless needs.

## Common tasks
- Rebuild macOS: `darwin-rebuild switch --flake .#<host>`.
- Rebuild NixOS: `sudo nixos-rebuild switch --flake .#<host>`.
- Update inputs: `nix flake update`.

## Troubleshooting
- Attribute renames: if `pkgs.system` warnings appear, use `pkgs.stdenv.hostPlatform.system`.
- Package renames: on macOS use `docker-desktop` instead of `docker`.
- If a profile change doesn’t load, ensure the host’s `profiles` list in `flake.nix` includes it.
