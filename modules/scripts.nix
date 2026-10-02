{ config, pkgs, ... }:

let
  vaultToggle = pkgs.writeShellScriptBin "vault-toggle" (builtins.readFile ./scripts/vault-toggle.sh);
  stripMetadata = pkgs.writeShellScriptBin "strip-metadata" (builtins.readFile ./scripts/strip-metadata.sh);
  brightnessCtl = pkgs.writeShellScriptBin "brightness-ctl" (builtins.readFile ./scripts/brightness-ctl.sh);
  hotspotStart = pkgs.writeShellScriptBin "hotspot-start" (builtins.readFile ./scripts/hotspot-start.sh);
  systemTelemetry = pkgs.writeShellScriptBin "system-telemetry" (builtins.readFile ./scripts/system-telemetry.sh);
  weatherFetch = pkgs.writeShellScriptBin "weather-fetch" (builtins.readFile ./scripts/weather-fetch.sh);
in
{
  environment.systemPackages = with pkgs; [
    gocryptfs
    exiftool
    jq
    vaultToggle
    stripMetadata
    brightnessCtl
    hotspotStart
    systemTelemetry
    weatherFetch
  ];
}
