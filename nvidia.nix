{ config, lib, pkgs, ... }:

let
  legacy390 = config.boot.kernelPackages.nvidiaPackages.legacy_390.overrideAttrs (old: {
    postInstall =
      lib.optionalString (old ? postInstall && old.postInstall != null) old.postInstall
      + ''
        if [ -n "$bin" ]; then
          ln -sf libglx.so.${old.version} "$bin/lib/xorg/modules/extensions/libglx.so"
        fi
      '';
  patches = old.patches ++ [
      ./patches/kernel-6.18-nv_workqueue_flush.patch
      ./patches/kernel-6.19.patch
      ./patches/kernel-7.0.patch
      ./patches/kernel-7.2.patch
    ];
  });
in
{
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.graphics.enable = true;
  boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];  

  services.xserver.videoDrivers = [ "nvidia" ];               
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];             
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    package = legacy390;
    powerManagement.enable = false;
#    prime = {							# Part of my personal config for my machine, replace PCI ID's with yours if you would need it.
#          sync.enable = true;
#          intelBusId  = "PCI:0:2:0";   
#          nvidiaBusId = "PCI:1:0:0";   
#        };
  };
  systemd.services = {
    systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
    systemd-suspend-then-hibernate.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
    systemd-hibernate.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
    systemd-hybrid-sleep.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
    systemd-homed.environment.SYSTEMD_HOME_LOCK_FREEZE_SESSION = "false";
  };
}
