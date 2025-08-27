{ lib, systemVars, ... }:
let
  inherit (systemVars)
    ssdDevice
    rootPartSize
    swapSize

    bootUsbDevice

    hddDevices
    hddPool
    ;
in
{
  disko.devices = {
    disk = {
      boot = {
        type = "disk";
        device = bootUsbDevice;
        content = {
          type = "table";
          format = "msdos";
          partitions = [
            {
              name = "ESP";
              part-type = "primary";
              start = "1M";
              end = "100%";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            }
          ];
        };
      };

      ssd = {
        type = "disk";
        device = ssdDevice;
        content = {
          type = "gpt";
          partitions = {
            root = {
              size = rootPartSize;
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };

            swap = {
              size = swapSize;
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };

            containerStorage = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/opt/ssd_store";
              };
            };
          };
        };
      };
    }
    // lib.attrsets.mapAttrs (name: devId: {
      type = "disk";
      device = devId;
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = hddPool;
            };
          };
        };
      };
    }) hddDevices;

    zpool = {
      "${hddPool}" = {
        type = "zpool";
        mode = {
          topology = {
            type = "topology";
            vdev = [
              {
                mode = "raidz1";
                members = lib.attrsets.mapAttrsToList (name: value: name) hddDevices;
              }
            ];
          };
        };

        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        mountpoint = "/opt/hdd_store";
        datasets = {
          media = {
            type = "zfs_fs";
            mountpoint = "/opt/hdd_store/media";
            options = {
              sharenfs = "rw=192.168.1.0/24,anonuid=70,anongid=70";
            };
          };

          files = {
            type = "zfs_fs";
            mountpoint = "/opt/hdd_store/files";
          };
        };
      };
    };
  };
}
