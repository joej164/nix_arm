{ config, pkgs, ... }:

{
  #Secrets stored in create /etc/nixos/smb-secrets with the following content (domain= can be optional)

  # For mount.cifs, required unless domain name resolution is not needed.
  environment.systemPackages = [ pkgs.cifs-utils ];

  fileSystems."/home/arm/jellyfin" = {
    device = "//192.168.68.78/jellyfin/media";
    fsType = "cifs";
    options = let
      automount_opts =
        "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      user_id = toString config.users.users.arm.uid;
      group_id = toString config.users.groups.arm.gid;

    in [
      "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=${user_id},gid=${group_id}"
    ];
  };
}