{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/virtualbox-demo.nix> ];

  # Let demo build as a trusted user.
# nix.settings.trusted-users = [ "demo" ];

# Mount a VirtualBox shared folder.
# This is configurable in the VirtualBox menu at
# Machine / Settings / Shared Folders.
# fileSystems."/mnt" = {
#   fsType = "vboxsf";
#   device = "nameofdevicetomount";
#   options = [ "rw" ];
# };

# By default, the NixOS VirtualBox demo image includes SDDM and Plasma.
# If you prefer another desktop manager or display manager, you may want
# to disable the default.
# services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
# services.xserver.displayManager.sddm.enable = lib.mkForce false;

# Enable GDM/GNOME by uncommenting above two lines and two lines below.
# services.xserver.displayManager.gdm.enable = true;
# services.xserver.desktopManager.gnome.enable = true;

# Set your time zone.
time.timeZone = "America/Los_Angeles";

# List packages installed in system profile. To search, run:
# \$ nix search wget
environment.systemPackages = with pkgs; [
   wget
   vim
   jellyfin
   jellyfin-web
   jellyfin-ffmpeg
   lsscsi
 ];

# Enable the OpenSSH daemon.
# services.openssh.enable = true;
services.jellyfin = {
  enable=true;
  openFirewall = true;
};


users.groups.arm.gid = 1001;

users.users.arm = {
        isNormalUser = true;
        home = "/home/arm";
        uid = 1001;
        homeMode = "755";
        group = "arm";
};

# Creating folders in home directory
systemd.tmpfiles.rules = [
        "d /home/arm/music 0755 arm arm"
        "d /home/arm/logs 0755 arm arm"
        "d /home/arm/media 0755 arm arm"
        "d /home/arm/config 0755 arm arm"
        "d /home/arm/db 0755 arm arm"
];

virtualisation.docker.enable = true;
users.extraGroups.docker.members = [ "demo" ];

virtualisation.oci-containers = {
        backend = "docker";
        containers = {
                arm = {
                        autoStart = true;
                        image = "docker.io/automaticrippingmachine/automatic-ripping-machine";
                        volumes = [
                          "/home/arm:/home/arm"
                          "/home/arm/music:/home/arm/music"
                          "/home/arm/logs:/home/arm/logs"
                          "/home/arm/media:/home/arm/media"
                          "/home/arm/config:/etc/arm/config"
                        ];
                        ports = ["8080:8080"];
                        environment = {
                          ARM_UID = "1001";
                          ARM_GID = "1001";
                        };
                        extraOptions = [
                                          "--privileged" 
                                          "--device=/dev/sr0:/dev/sr0"
                                       ];
                  };

        };
};

}
