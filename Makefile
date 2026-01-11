.PHONY: test boot switch build dry-build upgrade update generate-config list-generations clean full-maintenance

HOST ?= $(shell hostname)
NIXFLAGS :=
NIXCMD := sudo nixos-rebuild
NIXFLAKE := --flake .\#$(HOST)

switch test boot build dry-build:
	$(NIXCMD) $(NIXFLAGS) $@ $(NIXFLAKE)

update:
	nix flake update

upgrade: update switch

generate-config:
	sudo nixos-generate-config --show-hardware-config | nixpkgs-fmt >hosts/$(HOST)/hardware-configuration.nix

list-generations:
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

clean:
	sudo nix-collect-garbage --delete-older-than 30d
