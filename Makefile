# Variables (override these as needed)
HOST ?= $(shell hostname -s)
FLAKE ?= .#$(HOST)
HOME_TARGET ?= .#$(USER)@$(HOST)
SOPS_USER_KEY ?=
SOPS_USER_PUBKEY ?= $(if $(SOPS_USER_KEY),$(SOPS_USER_KEY).pub,)
SOPS_AGE_KEY_CMD ?= nix run nixpkgs#ssh-to-age -- -private-key -i "$(SOPS_USER_KEY)"
EXPERIMENTAL ?= --extra-experimental-features "nix-command flakes"

.PHONY: help install-nix install-nix-darwin darwin-rebuild nixos-rebuild \
	home-manager-switch nix-gc flake-update flake-update-homebrew flake-check \
	sops-check-key sops-host-recipient sops-user-recipient sops-verify \
	sops-edit-system sops-edit-home bootstrap-mac

help:
	@echo "Available targets:"
	@echo "  install-nix          - Install the Nix package manager"
	@echo "  install-nix-darwin   - Install nix-darwin using flake $(FLAKE)"
	@echo "  darwin-rebuild       - Rebuild the nix-darwin configuration"
	@echo "  nixos-rebuild        - Rebuild the NixOS configuration"
	@echo "  home-manager-switch  - Switch the Home Manager configuration using flake $(HOME_TARGET)"
	@echo "  nix-gc               - Run Nix garbage collection"
	@echo "  flake-update         - Update flake inputs"
	@echo "  flake-update-homebrew - Update brew and Homebrew taps together"
	@echo "  flake-check          - Check the flake for issues"
	@echo "  sops-check-key       - Check that SOPS_USER_KEY/SOPS_USER_PUBKEY are readable"
	@echo "  sops-host-recipient  - Print age recipient for this host SSH key"
	@echo "  sops-user-recipient  - Print age recipient for SOPS_USER_PUBKEY"
	@echo "  sops-verify          - Verify all encrypted secrets decrypt with SOPS_USER_KEY"
	@echo "  sops-edit-system     - Edit secrets/$(HOST).yaml"
	@echo "  sops-edit-home       - Edit secrets/$(HOST)/$(USER).yaml"
	@echo "  bootstrap-mac        - Install Nix and nix-darwin sequentially"

install-nix:
	@echo "Installing Nix..."
	@sudo curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
	@echo "Nix installation complete."
	

install-nix-darwin:
	@echo "Installing nix-darwin..."
	@nix run nix-darwin $(EXPERIMENTAL) -- switch --flake $(FLAKE)
	@echo "nix-darwin installation complete."

darwin-rebuild:
	@echo "Rebuilding darwin configuration..."
	@sudo darwin-rebuild switch --flake $(FLAKE)
	@echo "Darwin rebuild complete."

nixos-rebuild:
	@echo "Rebuilding NixOS configuration..."
	@sudo nixos-rebuild switch --flake $(FLAKE)
	@echo "NixOS rebuild complete."

home-manager-switch:
	@echo "Switching Home Manager configuration..."
	@home-manager switch --flake $(HOME_TARGET)
	@echo "Home Manager switch complete."

nix-gc:
	@echo "Collecting Nix garbage..."
	@nix-collect-garbage -d
	@echo "Garbage collection complete."

flake-update:
	@echo "Updating flake inputs..."
	@nix flake update
	@echo "Flake update complete."

flake-update-homebrew:
	@echo "Updating Homebrew inputs in lockstep..."
	@nix flake lock \
		--update-input brew-src \
		--update-input nix-homebrew \
		--update-input homebrew-bundle \
		--update-input homebrew-core \
		--update-input homebrew-cask
	@echo "Homebrew flake inputs updated together."

flake-check:
	@echo "Checking flake..."
	@nix flake check
	@echo "Flake check complete."

sops-check-key:
	@test -n "$(SOPS_USER_KEY)" || (echo "Set SOPS_USER_KEY to your local SOPS private SSH key path." >&2; exit 1)
	@test -n "$(SOPS_USER_PUBKEY)" || (echo "Set SOPS_USER_PUBKEY or use a public key at SOPS_USER_KEY.pub." >&2; exit 1)
	@test -r "$(SOPS_USER_KEY)" || (echo "Missing SOPS user key: $(SOPS_USER_KEY)" >&2; exit 1)
	@test -r "$(SOPS_USER_PUBKEY)" || (echo "Missing SOPS user public key: $(SOPS_USER_PUBKEY)" >&2; exit 1)

sops-host-recipient:
	@nix run nixpkgs#ssh-to-age -- -i /etc/ssh/ssh_host_ed25519_key.pub

sops-user-recipient: sops-check-key
	@nix run nixpkgs#ssh-to-age -- -i "$(SOPS_USER_PUBKEY)"

sops-verify: sops-check-key
	@set -e; \
	found=0; \
	for file in secrets/*.yaml secrets/*/*.yaml; do \
		[ -e "$$file" ] || continue; \
		found=1; \
		echo "Checking $$file"; \
		SOPS_AGE_KEY_CMD='$(SOPS_AGE_KEY_CMD)' sops -d "$$file" >/dev/null; \
	done; \
	[ "$$found" -eq 1 ] || echo "No encrypted secrets files found yet."

sops-edit-system: sops-check-key
	@SOPS_AGE_KEY_CMD='$(SOPS_AGE_KEY_CMD)' sops secrets/$(HOST).yaml

sops-edit-home: sops-check-key
	@mkdir -p secrets/$(HOST)
	@SOPS_AGE_KEY_CMD='$(SOPS_AGE_KEY_CMD)' sops secrets/$(HOST)/$(USER).yaml

bootstrap-mac: install-nix install-nix-darwin
