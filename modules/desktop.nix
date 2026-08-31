{ config, pkgs, ... }:

{
  # --- Pantheon: elementary OS's desktop environment (gala compositor, Wayland) ---
  # Pulls in its own session (pantheon-wayland), top panel (Wingpanel), dock,
  # app launcher, Files, Terminal, Screenshot, Photos, notifications, and
  # GTK/icon theming — no separate compositor config or dotfile symlinking
  # needed, unlike the previous Hyprland setup.
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.desktopManager.pantheon.enable = true;

  # Keyboard layout for LightDM/XWayland; Pantheon's own session picks this
  # up too.
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  security.polkit.enable = true;

  # Native Wayland backend for Electron/Chromium-based apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Comfortable trackpad defaults for a laptop — tap-to-click and natural
  # scrolling aren't on by default, and gala reads touchpad settings from
  # GSettings at runtime (not services.libinput, which is X11-only), so
  # they're set here as a dconf default instead.
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
        natural-scroll = true;
        two-finger-scrolling-enabled = true;
      };
    }
  ];
}
