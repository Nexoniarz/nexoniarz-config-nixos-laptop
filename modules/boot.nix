{ config, lib, pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.limine = {
    enable = true;
    maxGenerations = 5;

    # Gruvbox, to match the icon theme.
    style = {
      wallpapers = [ ];   # Solid background; a path here would be used instead
      interface = {
        branding = "NixOS";
        brandingColor = "fabd2f";
        helpColor = "928374";
        helpColorBright = "d79921";
      };
      graphicalTerminal = {
        foreground = "ebdbb2";
        background = "00282828";
        brightForeground = "fbf1c7";
        palette = "282828;cc241d;98971a;d79921;458588;b16286;689d6a;a89984";
        brightPalette = "928374;fb4934;b8bb26;fabd2f;83a598;d3869b;8ec07c;ebdbb2";
        margin = 32;
      };
    };
  };

  boot.kernelPackages = pkgs.linuxPackages;
  boot.supportedFilesystems = [ "fuse" ];
  programs.fuse.userAllowOther = true;

  # zram instead of disk swap: nothing sensitive is written to disk in
  # plaintext. systemd's gpt-auto-generator would otherwise re-activate the
  # swap partition hardware-configuration.nix still lists, hence the kernel
  # param. / /home /nix /boot are declared explicitly there, so they don't
  # depend on gpt-auto.
  zramSwap.enable = true;
  swapDevices = lib.mkForce [ ];

  # Unlike the desktop this doesn't carry acpi_enforce_resources=lax: that
  # only exists there to let lm_sensors poke the Super I/O chip behind ACPI's
  # back, and on a laptop — where ACPI genuinely owns the EC that asusd talks
  # to — relaxing it is how you get fan/thermal weirdness. CPU temps come
  # from k10temp, everything else from asusd.
  boot.kernelParams = [ "systemd.gpt_auto=0" ];
}
