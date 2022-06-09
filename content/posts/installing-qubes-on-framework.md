---
title: "Installing Qubes on the Framework Laptop"
date: 2022-06-08T21:52:26-07:00
draft: false
toc: false
images:
tags:
  - qubes
  - framework
---

Gist from Github:

{{< gist EncryptedGiraffe 39eea9cc7598d09a98711efe7c7a2c89 >}}

---

### Reproduced in text form (may be outdated): 

This was my process getting Qubes OS running on the Framework Laptop. I use a dark theme, and these are the scaling numbers that looked good to me. I also run debian minimal for all templates. XFCE.
Specs: i5-1135G7, 16GB RAM, 512GB SN850 NVMe, AX210 no vPro

In the future I may try installing KDE, or salting some of this configuration, For now however, this is the list of settings I changed.

Install:
- Disable Secure Boot, Hyperthreading in BIOS, make sure VT-x and VT-d are on (they are by default)
- Install the ISO however you want. I chose BTRFS
- Reboot, complete Final Configuration, then shutdown
- Reboot into installer rescue mode, get a shell. Run ```efibootmgr -v -c -u -L QubesOS -l /EFI/qubes/grubx64.efi -d /dev/nvme0n1 -p 1```
- Boot, connect to internet. I USB tethered my phone by setting sys-usb to provide network, and adding the network-manager service then switching sys-firewall to get network from sys-usb
- run dom0 updates, install kernel-latest-qubes-vm

Dark theme and scaling:
- System tools > Appearance > Style = adwaita dark
- System tools > Window Manager > Theme = slick
- System tools > Panel > Row Size = 36
- System tools > Appearance > Fonts > dpi = 130
- Add ```xfcd4-panel -r``` as a command in Session and Startup > Application Autostart
- Install ```qt5-qtstyleplugins``` in dom0
- Run ```echo QT_QPA_PLATFORMTHEME=gtk2 >> /etc/environment```
- Change ```Xft.dpi: 130``` in dom0

To get debian-11-minimal templates to work with xterm scaled and a dark theme:
- in ```/etc/X11/Xresources/X11-common```
 ```
 Xft.dpi: 130
 xterm*faceName: Monospace
 xterm*faceSize: 12
 ```
- create ```~/.config/gtk3.0/settings.ini``` in ```/etc/skel```
 ```
 [Settings]
 gtk-font-name=DejaVu Sans Book 12
 gtk-theme-name=Adwaita-dark
 gtk-icon-theme=gnome
 ```
- create ```.gtkrc-2.0``` in ```/etc/skel```
 ```
 include "/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc"
 style "user-font"
 {
  font_name="DejaVu Sans Book"
  }
  widget_class "*" style "user-font"
  gtk-font-name="DejaVu Sans Book 12"
  gtk-theme-name="Adwaita-dark"
  gtk-icon-theme-name="gnome"
  ```
 - create ```.Xresources``` in ```/etc/skel```
  ```
  Xft.dpi: 130
  xterm*faceName: Monospace
  xterm*faceSize: 12
  ```
At the very beginning, my (debian) sys-usb constantly sent notifications of empty devices attaching and disconnecting. (Device "" was removed)  
Other people have reported this as well. For me this problem went away after updating to ```kernel-latest-qubes-vm```

Getting the AX210 no vPro wifi working:
this one has been a pain in the ass. so far, the only way I can get it working is this:
Using kernel 5.10.109-1
Install ```firmware-iwlwifi``` in template
On VM boot:
- Get a root terminal
- ```rm /lib/firmware/iwlwifi-ty-a0-gf-a0.pnvm```
- ```modprobe -r iwlmvm && modprobe -r iwlwifi```
- ```modprobe iwlwifi && modprobe iwlmvm```
This gets the wifi working until I shutdown
Further work to be done here for sure

Thanks to everyone on the forums and elsewhere that I've used as guides to get everything working in the first place!


Other notes:
use apt-cacher-ng!  
to get a debian-11-minimal template to run AppImages, install ```fuse, libasound2```
