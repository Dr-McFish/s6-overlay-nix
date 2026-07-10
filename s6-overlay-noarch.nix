# s6-overlay-noarch

{ pkgs }: pkgs.stdenv.mkDerivation rec {

  pname = "s6-overlay";
  version = "3.2.3.0";

  src = fetchTarball {
    url = "https://github.com/just-containers/s6-overlay/releases/download/v${version}/s6-overlay-noarch.tar.xz";
    sha256 = "066p7zb3gk3dmx7sj2mwdv82qc82bb3afj62v9ldk75gqv3h0v6p";
  };

  dontBuild = true;

  installPhase = ''
    cp -r ${src} $out
  '';

  meta = {
    license = pkgs.lib.licenses.isc;
  };
}

