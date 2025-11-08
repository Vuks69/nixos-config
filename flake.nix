{
  description = "NixOS configuration (flake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, nixos-unstable, nixpkgs-unstable, agenix, ... }@inputs: {
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
          nixos-unstable = import nixos-unstable  {
            system = "x86_64-linux";
            config = { allowUnfree = true; };
          };
          nixpkgs-unstable = import nixpkgs-unstable  {
            system = "x86_64-linux";
            config = { allowUnfree = true; };
          };
        };
      };
    };
  };
}
