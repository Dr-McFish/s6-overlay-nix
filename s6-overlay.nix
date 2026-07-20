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
    license = lib.licenses.isc;
  };
}
