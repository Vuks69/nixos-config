{
  description = "NixOS configuration (flake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, unstable, agenix, ... }@inputs: {
    nixosConfigurations = {
      phoenix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          agenix.nixosModules.default
          ./hosts/phoenix/flake.nix
          {
            environment.systemPackages = [ agenix.packages."x86_64-linux".default ];
          }
        ];
        specialArgs = {
          unstable = import unstable {
            system = "x86_64-linux";
            config = { allowUnfree = true; };
          };
        };
      };
    };
  };
}
