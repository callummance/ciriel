{
  groups = {
    callum = {
      gid = 2002;
    };
    ciriel-media = {
      gid = 2001;
    };
  };
  mount-points = {
    hdd-store = "/opt/hdd_store";
    ssd-store = "/opt/ssd_store";
  };
  users = {
    callum = {
      groups = [
        "ciriel-media"
        "wheel"
        "sudo"
      ];
      type = "normal";
      uid = 2002;
    };
    ciriel-media = {
      type = "system";
      uid = 2001;
    };
  };
}
