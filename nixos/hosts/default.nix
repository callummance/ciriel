{
  self,
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  globalConfig = import "${self}/vars/global.nix";
  systemVars = import "${self}/vars/ciriel.nix";
  commonVars = import "${self}/vars/default.nix";
in
{
  flake.nixosConfigurations = {
    ciriel = nixosSystem {
      specialArgs = { inherit self inputs globalConfig systemVars commonVars; };
      modules = [
        inputs.disko.nixosModules.disko
        ./ciriel
      ];
    };
  };
}
