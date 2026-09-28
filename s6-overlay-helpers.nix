{
  lib,
  stdenv,
  execline,
  skalibs,
  fetchFromGitHub,
  pkg-config,
  nsss,
  withNsss ? false,
}:

stdenv.mkDerivation rec {
  pname = "s6-overlay-helpers";
  version = "0.1.2.2";

  src = fetchFromGitHub {
    owner = "just-containers";
    repo = "s6-overlay-helpers";
    rev = "v${version}";
    hash = "sha256-aZd+U8cPwQ0bn9FuhTvlomtEnsi6wkSSUb34B9qcww8=";
  };

  # Because of security reasons, it is not possible to have setuid binaries
  # in nix store, therefore we have to modify the script
  postPatch = ''
    sed -i 's/^s6-overlay-suexec\t04755/s6-overlay-suexec\t0755/' package/modes
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    execline
    skalibs
  ]
  ++ lib.optional withNsss nsss;

  configureFlags = [
    "--disable-allstatic"
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-pkgconfig=pkg-config"
    "--enable-pkgconfig"
    "--enable-absolute-paths"
  ]
  ++ lib.optionals withNsss [
    "--enable-nsss"
  ];

  meta = {
    description = "Helpers for s6-overlay";
    homepage = "https://github.com/just-containers/s6-overlay-helpers/";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
