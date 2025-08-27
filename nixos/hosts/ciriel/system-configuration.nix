{
  self,
  inputs,
  nixpkgs,
  pkgs,
  globalConfig,
  systemVars,
  ...
}:
{
  system.stateVersion = "25.05";

  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs = {
      forceImportRoot = false;
      devNodes = "/dev/disk/by-path";
    };

    loader.grub = {
      enable = true;
      devices = [
        systemVars.bootUsbDevice
      ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      UseDns = true;
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  security.sudo-rs.enable = true;

  environment.systemPackages = [
    pkgs.git
    pkgs.sudo-rs
    pkgs.vim
  ];

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocales = [
      "en_GB/ISO-8859-1"
      "en_US.UTF-8/UTF-8"
    ];
  };

  networking.hostId = "c273cfc1";
}
