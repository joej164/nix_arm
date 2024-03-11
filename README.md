# nix_arm
NixOS Config to get Automatic Ripping Machine running on my server

## Overview
Sets up the server, downloads docker, configures the file structure, then downloads the Docker Image and installs it on the server and sets it to auto run.

Process
- Install NixOS on the machine
- Copy over arm.nix, samba-client.nix, samba-secrets
- Update samba-secrets
- Run `nixos-rebuild switch`
- Reboot the machine
- Run `nixos-rebuild switch` again
- Verify the container is running (docker ps)
- Update the owner of the /home/arm/config files
- Update the owner of the /home/arm/jellyfin folder if needed
- Put the API keys into ARM

## Issues
May still need to change permissions on some of the files and directories in the /home/arm directory.  This is also an issue in the notes from the dev, specifically the files in the /home/arm/config folder.
`chown arm:arm <filename>`

## Post install config
- Update the settings files with OMDB and TMDB API Keys

## Things to implement still
- Install Tailscale
- Figure out how to map SAMBA Drives to allow the copying of files off the Server (https://nixos.wiki/wiki/Samba)

## Resolved Issues

### SCSI Device Drivers
After reboot, the container won't see the drives fully, need to do the command below after each reboot.  Found an article on makemkv webside about needing the sdX and sgX files to get things working.
`sudo modprobe sg`

Solution was to load the `sg` kernel driver at boot

### Intel Quicksync Support
As of 24-Feb-2024 the Dockerimage does not support Intel Quicksync
- Add Quicksync support (https://forum.openmediavault.org/index.php?thread/38696-how-to-activate-intel-quick-sync-in-docker-jellyfin-handbrake/)
