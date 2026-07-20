# s6-overlay.nix

{
  lib,
  symlinkJoin,
  s6-overlay-noarch,
  s6-overlay-helpers,
  s6,
  s6-rc,
  s6-linux-init,
  s6-portable-utils,
  execline,
}:
symlinkJoin {
  pname = "s6-overlay";
  version = import ./version.nix;

  paths = [
    s6
    s6-rc
    s6-linux-init
    s6-portable-utils
    execline
    s6-overlay-noarch
    s6-overlay-helpers
  ];

  meta = {
    description = "s6 overlay for containers (includes execline, s6-linux-utils & a custom init)";
    homepage = "https://github.com/just-containers/s6-overlay/";
    platforms = lib.platforms.linux;
    maintainers = [ ];
    license = lib.licenses.isc;
  };
}
