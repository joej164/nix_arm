{ config, pkgs, ... }:

{

  # List packages installed in system profile. To search, run:
  # \$ nix search wget
  environment.systemPackages = with pkgs; [
    lsscsi

    # The following are for Intel QSV, but docker image doesn't support
    intel-vaapi-driver
    libva
    libdrm
  ];

  # this config is to load the SCSI generic drives at boot
  # turns out MakeMKV needs both the sdX and sgX files to work
  boot.kernelModules = [ "sg" ];

  users.groups.arm.gid = 1001;

  users.users.arm = {
    isNormalUser = true;
    home = "/home/arm";
    uid = 1001;
    homeMode = "755";
    group = "arm";
    extraGroups = [ "cdrom" "video" ];
  };

  # Creating folders in home directory
  # The base image ends up creating a lot of the folders as root, so this makes sure
  # the folders are setup with the right permissions
  #
  # NOTE: likely will also have to change permissions in files in the /home/arm/config directory (see readme)
  systemd.tmpfiles.rules = [
    "d /home/arm/music 0755 arm arm"
    "d /home/arm/Music 0755 arm arm"
    "d /home/arm/logs 0755 arm arm"
    "d /home/arm/media 0755 arm arm"
    "d /home/arm/media/raw 0755 arm arm"
    "d /home/arm/media/transcode 0755 arm arm"
    "d /home/arm/media/transcode/movies 0755 arm arm"
    "d /home/arm/media/transcode/unidentified 0755 arm arm"
    "d /home/arm/media/completed 0755 arm arm"
    "d /home/arm/movies 0755 arm arm"
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
        ports = [ "8080:8080" ];
        environment = {
          ARM_UID = "1001";
          ARM_GID = "1001";
        };
        extraOptions = [
          "--privileged"
          "--device=/dev/sr0:/dev/sr0"
          "--device=/dev/sg0:/dev/sg0"
          "--device=/dev/sr1:/dev/sr1"
          "--device=/dev/sg1:/dev/sg1"
          "--device=/dev/dri/renderD128:/dev/dri/renderD128" # For intel quicksync
          "--device=/dev/dri/card0:/dev/dri/card0" # For intel quicksync
        ];
      };

    };
  };

}