{
  self, 
  pkgs,
  nixpkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.k3s

    pkgs.kubernetes-helm
    pkgs.kubernetes-helmPlugins.helm-git

    pkgs.fluxcd
  ];

  networking.firewall.allowedTCPPorts = [
    6443 #k3s
  ];

  services.k3s = {
    enable = true;
    role = "server";
  };
}