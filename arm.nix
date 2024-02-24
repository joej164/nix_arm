{ config, pkgs, ... }:

{


# List packages installed in system profile. To search, run:
# \$ nix search wget
environment.systemPackages = with pkgs; [
   lsscsi
 ];

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
users.extraGroups.docker.members = [ "joe" ];

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
                                          "--device=/dev/sr0:/dev/sr1"
                                       ];
                  };

        };
};

}
