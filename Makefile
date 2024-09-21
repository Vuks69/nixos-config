.PHONY: test boot switch build dry-build upgrade full-maintenance generate-config list-generations clean full-maintenance

NIXCONFIG = ./configuration.nix # relative to the makefile
NIXCMD = sudo nixos-rebuild
NIXFLAGS = -I nixos-config=$(NIXCONFIG)

test boot switch build dry-build:
	$(NIXCMD) $(NIXFLAGS) $@

upgrade:
	$(NIXCMD) $(NIXFLAGS) switch --upgrade

full-maintenance: clean upgrade generate-config

generate-config:
	sudo nixos-generate-config --show-hardware-config | nixpkgs-fmt >hardware-configuration.nix

list-generations:
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

clean:
	sudo nix-collect-garbage --delete-older-than 30d
