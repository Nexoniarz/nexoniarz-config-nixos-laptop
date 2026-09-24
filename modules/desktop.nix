{ config, pkgs, ... }:

{
  # Plasma ships a proper Wayland session (KWin) with solid Xwayland
  # support; xserver stays on for that Xwayland layer and for the xkb
  # layout below, not because the session itself needs it.
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;

  # SDDM is KDE's own greeter — Qt-based, and launches Wayland sessions
  # natively, Plasma included.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  services.tumbler.enable = true;
  services.gvfs.enable = true;

  # xserver.nix installs xterm unconditionally; Konsole is the terminal here.
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Native Wayland backend for the Electron/Chromium apps (vesktop, chromium,
  # lmstudio) instead of letting them fall back to Xwayland.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Laptop trackpad. This writes an Xorg/libinput snippet, so it covers
  # Xwayland and any X11 session — KWin's own Wayland session keeps touchpad
  # settings per-device in ~/.config/kcminputrc instead (System Settings →
  # Mouse & Touchpad), and those keys are keyed by the device's VID/PID, so
  # they can't be pinned down from another machine. Set them once there, or
  # bring in plasma-manager if you want them declarative too.
  services.libinput.enable = true;
  services.libinput.touchpad = {
    tapping = true;
    naturalScrolling = true;
    disableWhileTyping = true;
  };

  # Hybrid graphics: KWin normally picks the right GPU on its own, but if a
  # session ever comes up rendering on the RTX 4050 (hot, loud, worse battery)
  # pin it to the AMD iGPU — bus 35:00.0 from `lspci`. Verify the path exists
  # before enabling, an invalid device makes KWin fail to start:
  #   ls /dev/dri/by-path/
  # environment.sessionVariables.KWIN_DRM_DEVICES =
  #   "/dev/dri/by-path/pci-0000:35:00.0-card";

  # Icon/cursor theme packages. Plasma has no gsettings-style declarative
  # knob for this the way Pantheon did — pick them in System Settings, or
  # bring in plasma-manager later for a fully declarative setup.
  environment.systemPackages = [
    pkgs.gruvbox-plus-icons
    pkgs.bibata-cursors
  ];

  fonts.packages = with pkgs; [
    corefonts
    dejavu_fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    inter
    liberation_ttf
    roboto
  ];
}
