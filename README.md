# nvidia-390xx-nixos
NixOS module that builds nvidia-390xx drivers

## Installation:
- Put nvidia.nix into /etc/nixos
- Download patches and put them into /etc/nixos/patches/
- Add nvidia.nix into imports in your /etc/nixos/configuration.nix
```
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
    ];
```
- Run 
```
sudo nixos-rebuild switch
```
- Reboot

### Keep in mind that it wouldn't work on the latest kernel! You need LTS kernel for this!



### Made with help of MiMo-V2.6-Flash. 
