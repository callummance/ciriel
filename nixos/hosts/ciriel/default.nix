{
  self,
  inputs,
  nixpkgs,
  ...
}:
let
  modules = "${self}/modules";
in
{
  imports = [
    ./disko-layout.nix
    ./system-configuration.nix
    ./hardware-configuration.nix
    ./users.nix

    "${modules}/kubernetes.nix"
  ];
}
