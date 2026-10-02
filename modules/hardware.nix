{ config, lib, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Hybrid graphics on the ASUS TUF Gaming A15 (FA507NU): AMD Radeon 680M
  # iGPU drives the internal panel, NVIDIA RTX 4050 Max-Q is offload-only.
  # Run something on the dGPU with `nvidia-offload <command>`.
  # Bus IDs from `lspci` on this machine: 01:00.0 (NVIDIA) -> PCI:1:0:0,
  # 35:00.0 (AMD) -> PCI:53:0:0.
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Fixes suspend/resume hangs common with NVIDIA on laptops.
    powerManagement.enable = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:53:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  # No LIBVA/NVD env vars here (unlike the PC): video decoding runs on the
  # AMD iGPU, which libva picks automatically (radeonsi).

  # asusctl (fan curves, keyboard backlight, battery charge limit) and
  # supergfxctl (dGPU power-state switching), from asus-linux.org.
  services.asusd.enable = true;
  services.supergfxd.enable = true;

  hardware.opentabletdriver.enable = true;
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;      # Battery level of connected devices
        FastConnectable = true;   # Faster reconnects, more power draw
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
  # Plasma ships its own Bluetooth UI (Bluedevil); blueman just duplicated it.

  boot.extraModprobeConfig = ''
    # DualSense/PS4 pads pair over Bluetooth then drop instantly; broken
    # ERTM in many adapters. Disabling it is the standard fix.
    options bluetooth disable_ertm=1
  '';

  # Blog V4 needs the rtlsdrblog fork of librtlsdr, which is what
  # pkgs.rtl-sdr already is here. Also blacklists the DVB-T drivers.
  hardware.rtl-sdr.enable = true;

  # For ddcutil on an external monitor; the internal panel uses the kernel
  # backlight instead (brightness-ctl picks whichever applies).
  hardware.i2c.enable = true;

  services.printing.enable = true;
}
