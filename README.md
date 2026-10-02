# nexoniarz-config-nixos-laptop

My personal NixOS configuration for an ASUS TUF Gaming A15 (FA507NU).
Shares its layout and settings with my PC config
([nexoniarz-config-nixos](https://github.com/Nexoniarz/nexoniarz-config-nixos));
only the hardware differs.

## Overview

- **OS:** NixOS 26.05 (unstable channel)
- **Desktop:** KDE Plasma 6 on Wayland (KWin), SDDM
- **Bootloader:** Limine
- **Terminal:** Konsole
- **Shell:** Zsh
- **Audio:** PipeWire
- **CPU:** AMD Ryzen 5 7535HS
- **GPU:** AMD Radeon 680M (iGPU, drives the panel) + NVIDIA RTX 4050 Max-Q
  (PRIME render offload only; run things on it with `nvidia-offload <command>`)
- **Laptop control:** asusctl (fans, keyboard backlight, charge limit) + supergfxctl (dGPU power state)

## Layout

| File | Contents |
|---|---|
| `configuration.nix` | Imports only |
| `modules/boot.nix` | Limine, kernel, zram/swap |
| `modules/networking.nix` | NetworkManager, firewall, DNS-over-TLS, MAC randomization |
| `modules/locale.nix` | Timezone, locale, console keymap |
| `modules/nix-settings.nix` | Nix features, GC, unfree |
| `modules/security.nix` | sysctl hardening, sudo, firejail, GnuPG, polkit |
| `modules/hardware.nix` | Hybrid graphics (PRIME offload), ASUS daemons, tablet, Bluetooth, I2C, RTL-SDR, printing |
| `modules/audio.nix` | PipeWire |
| `modules/desktop.nix` | Plasma, SDDM, fonts, theming |
| `modules/users.nix` | Account, shell, Steam, Flatpak |
| `modules/apps.nix` | Installed packages, nix-ld |
| `modules/default-apps.nix` | MIME associations |
| `modules/scripts.nix` | Custom scripts in `modules/scripts/` (vault, metadata stripping, brightness, Wi-Fi hotspot, telemetry, weather) |
| `modules/fastfetch.nix` | Installs `configs/fastfetch/config.jsonc` system-wide |
| `modules/firefox.nix` | Firefox, with prefs from `configs/firefox/prefs.js` (reapplied each start, not locked) |
| `configs/` | Plain app config files (Firefox prefs, fastfetch) used by the modules |

---

*Made by **Nexoniarz***
