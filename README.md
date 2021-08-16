# Yet Another ArchLinux Automate Script (YAAAS)
This repository contains all of the configuration that I made for my ArchLinux VM run on VMware. This is my configuration, and might not work and suit well your needs. If you want to use Arch, I think you should check out Arch Wiki, because you can know a lot more things than just run a little script like this. But if you are lazy (You shouldn't!), or you want to have a base script for creating the automate script that suit your needs, don't use mine, use others like the one that [ChrisTitus made](https://github.com/ChrisTitusTech/ArchMatic). And if you want to install Arch on VM, don't use mine either, please use the [official VM images](https://gitlab.archlinux.org/archlinux/arch-boxes/-/jobs/31700/artifacts/browse/output). But anyway, if you want, just feel free to use it.

---
## Disclaimer
This script do make change to your system, so please **USE AT YOUR OWN RISKS**.

__**I WILL NOT BE RESPONSIBLE FOR ANY DAMAGES MADE TO YOUR COMPUTER BY RUNNING THIS SCRIPT.**__

I suggest you to read the source of all files in this repository to know what the scripts do and how to fix the problems if you run into later on.

---
## Requirements
Not much, just a UEFI-enabled machine (because it will install Arch with UEFI boot mode in mind) and a stable Internet connection.

---
## What the script will do?
It will just install the base installation of Arch that I'm suitable of, but iw WILL NOT partition your drive. So before executing these script, please partition the drive first.
Also, it will ask you a few questions before and during the installation, so please sat down in front of it and answer what it's asked for.

---
## How to use?
First of all, create and boot into the ArchLinux installation media. After that, partition your drive, clone this repository's master branch and run `isoBCH.sh`. After the script done executing, it will change root (a.k.a chroot) to your new installation. If then, go to your root folder and execute `isoCHR.sh`. At last, the script will prompt you to reboot the system. Do as it say and you are done!
