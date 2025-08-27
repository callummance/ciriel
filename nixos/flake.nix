{
  description = "Basic deployment for my home server based on k3s";

  inputs = {
    #nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    #flake-parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    #disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { flake-parts, disko, nixpkgs, ... }@inputs:
    let
      linuxIntelArch = "x86_64-linux";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        linuxIntelArch
      ];

      imports = [
        ./hosts
      ];
    };
}
