{ config, pkgs, ... }:

{
  # Every installed package — GUI apps, CLI tools, and dev toolchains alike.
  # If it's "install X", it goes here.
  users.users."nexoniarz".packages = with pkgs; [
    # Hardware control (Pantheon itself ships Files/Terminal/Screenshot/
    # notifications/dock/launcher — see services.desktopManager.pantheon
    # in modules/desktop.nix, nothing to list here for those)
    brightnessctl              # Backlight brightness (internal laptop panel)
    ddcutil                    # DDC/CI brightness (external monitors)
    lm_sensors                 # sensors-detect helps ddcutil find I2C buses; also feeds asusctl
    networkmanager             # nmcli, for the Wi-Fi hotspot script

    # Apps
    blender
    gimp
    inkscape
    vesktop
    tor-browser
    ffmpeg-full
    vlc
    filezilla
    chromium

    # Games
    prismlauncher
    pkgs.osu-lazer-bin

    # Dev: compilers, runtimes, languages
    glibc
    musl
    cmake
    gnumake # Provides the 'make' command
    gcc
    python3
    openjdk25
    claude-code # AI Developer Assistant
  ];

  # Global command-line utilities available everywhere
  environment.systemPackages = with pkgs; [
    git
    gh # GitHub CLI — was only installed ad-hoc before (login didn't survive)
    vim
    fastfetch
    gparted
    firejail
    gnupg
    lmstudio
    p7zip
    unzip
    unrar
    libreoffice # GTK3 build — matches Pantheon's native GTK theming, unlike the Qt build
  ];
}
