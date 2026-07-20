# s6-overlay-noarch

{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "s6-overlay";
  version = import ./version.nix;

  src = fetchFromGitHub {
    owner = "just-containers";
    repo = "s6-overlay";
    rev = "v${version}";
    hash = "sha256-JR7MiiFI1uJQthx8IU6vA6C0buqNJKlbu6D+gVgVXGM=";
  };

  buildPhase = ''
    runHook preBuild
    make rootfs-overlay-noarch-tarball
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp output/s6-overlay-noarch.tar.xz $out/
    runHook postInstall
  '';

  meta = {
    license = lib.licenses.isc;
  };
}
