# s6-overlay.nix

{ symlinkJoin
, s6-overlay-noarch
, s6-overlay-helpers
, s6
, s6-rc
, s6-linux-init
, s6-portable-utils
, execline  
}:
symlinkJoin {
  name = "s6-overlay";
  paths = [
    s6
    s6-rc
    s6-linux-init
    s6-portable-utils
    execline  
    s6-overlay-noarch
    s6-overlay-helpers
  ];
}

