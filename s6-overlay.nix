# s6-overlay.nix

{ pkgs }:
let s6-overlay-noarch = import ./s6-overlay-noarch.nix;
    s6-overlay-helpers = import ./s6-overlay-helpers.nix; in
pkgs.symlinkJoin {
  name = "s6-overlay";
  paths = [
    pkgs.s6
    pkgs.s6-rc
    pkgs.s6-linux-init
    pkgs.s6-portable-utils
    pkgs.execline  
    (s6-overlay-noarch { inherit pkgs; })
    (s6-overlay-helpers (with pkgs; { inherit lib stdenv execline skalibs fetchFromGitHub; }))
  ];
  #postBuild = ''
  #  rm -rf $out/run $out/var
  #  mkdir -p $out/run $out/var
  #  ln -s /run $out/var/run
  #'';
}

