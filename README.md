# nix_arm
NixOS Config to get Automatic Ripping Machine running on my server

## Overview
Sets up the server, downloads docker, configures the file structure, then downloads the Docker Image and installs it on the server and sets it to auto run.

## Issues
May still need to change permissions on some of the files and directories in the /home/arm directory.  This is also an issue in the notes from the dev
`chown arm:arm <filename>`

After reboot, the container won't see the drives fully, need to do the command below after each reboot.  Found an article on makemkv webside about needing the sdX and sgX files to get things working.
`sudo modprobe sg`

## Post install config
- Update the settings files with OMDB and TMDB API Keys

## Things to implement still
- Figure out a way to run the modprobe command or do what it's doing without the command
- Install Tailscale
- Figure out how to map SAMBA Drives to allow the copying of files off the Server