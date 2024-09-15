.PHONY: test switch list-generations clean

NIXCONFIG = ./configuration.nix
NIXCMD = sudo nixos-rebuild
NIXFLAGS = -I nixos-config=$(NIXCONFIG)

test:
	$(NIXCMD) $(NIXFLAGS) test

switch:
	$(NIXCMD) $(NIXFLAGS) switch

list-generations:
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

clean:
	sudo nix-collect-garbage --delete-older-than 30d
