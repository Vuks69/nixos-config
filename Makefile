.PHONY: test boot switch dry-build list-generations clean

NIXCONFIG = ./configuration.nix # relative to the makefile
NIXCMD = sudo nixos-rebuild
NIXFLAGS = -I nixos-config=$(NIXCONFIG)

test:
	$(NIXCMD) $(NIXFLAGS) test

boot:
	$(NIXCMD) $(NIXFLAGS) boot

switch:
	$(NIXCMD) $(NIXFLAGS) switch

dry-build:
	$(NIXCMD) $(NIXFLAGS) dry-build

generate-config:
	sudo nixos-generate-config --show-hardware-config >hardware-configuration.nix

list-generations:
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

clean:
	sudo nix-collect-garbage --delete-older-than 30d
