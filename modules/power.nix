{ config, lib, pkgs, ... }:

{
  # Suspend-to-RAM support and the powersave plumbing Plasma builds on:
  # plasma6.nix turns powerdevil and upower on when this is set, and it
  # defaults to true — spelled out here because on a laptop it matters.
  powerManagement.enable = true;

  # Backs Plasma's Power Profiles switcher (Performance / Balanced /
  # Power Saver in the battery applet). Plasma already defaults it on; kept
  # explicit since it's the one knob that actually changes CPU behaviour.
  # Mutually exclusive with tlp and auto-cpufreq — don't add either.
  services.power-profiles-daemon.enable = true;

  # Lid behaviour. Closing the lid suspends on battery, but only locks when
  # docked or on AC, so an external-monitor setup keeps running with the lid
  # shut. Renamed options: this is services.logind.settings.Login now, the
  # old services.logind.lidSwitch spelling is deprecated in 26.05.
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked = "ignore";
    HandlePowerKey = "suspend";
  };

  # Hibernate isn't available and won't be: swap is zram-only (see
  # modules/boot.nix), and security.protectKernelImage in modules/security.nix
  # blocks the kexec path hibernation resume needs anyway.

  # Battery longevity is asusd's department rather than a NixOS option —
  # there's no hardware.asus module in nixpkgs. Set it once and asusd
  # persists it across reboots:
  #   asusctl -c 80        # stop charging at 80%
  #   asusctl -c 100       # back to full, before a trip
  # Fan curves and keyboard lighting likewise: `asusctl profile -l`,
  # `asusctl aura -h`.

  # amd_pstate is left at the kernel's own default. Forcing
  # "amd_pstate=active" is the usual tweak for Zen 3+ laptops, but 6.18
  # already picks it when the firmware advertises CPPC, so pinning it here
  # would only matter if the BIOS regressed:
  # boot.kernelParams = [ "amd_pstate=active" ];

  environment.systemPackages = with pkgs; [
    powertop      # `powertop --auto-tune` and per-process wakeup accounting
    acpi          # quick battery/thermal readout from a terminal
  ];
}
