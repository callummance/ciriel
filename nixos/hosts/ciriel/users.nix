{
  self,
  lib,
  globalConfig,
  ...
}:
let
  commonVars = import "${self}/vars";

  users = builtins.mapAttrs (
    user: data:
    {
      uid = data.uid;
      group = user;
    }
    // lib.attrsets.optionalAttrs (data ? groups) { extraGroups = data.groups; }
    // lib.attrsets.optionalAttrs (data.type == "normal") { isNormalUser = true; }
    // lib.attrsets.optionalAttrs (data.type == "system") { isSystemUser = true; }
  ) globalConfig.users;

  groups = builtins.mapAttrs (group: data: {
    gid = data.gid;
  }) globalConfig.groups;
in
{
  users.users = {
    root = {
      openssh.authorizedKeys.keys = commonVars.authorizedSSHKeys;
    };
  }
  // users;
  users.groups = groups;
}
