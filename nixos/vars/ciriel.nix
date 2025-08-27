{
  ssdDevice = "/dev/disk/by-path/virtio-pci-0000:05:00.0";
  rootPartSize = "10G";
  swapSize = "1G";

  bootUsbDevice = "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003";

  hddDevices = {
    hdd1 = "/dev/disk/by-path/virtio-pci-0000:06:00.0";
    hdd2 = "/dev/disk/by-path/virtio-pci-0000:07:00.0";
    hdd3 = "/dev/disk/by-path/virtio-pci-0000:08:00.0";
    hdd4 = "/dev/disk/by-path/virtio-pci-0000:09:00.0";
  };
  hddPool = "hdd_store";
}