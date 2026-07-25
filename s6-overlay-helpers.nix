{
  lib,
  stdenv,
  execline,
  skalibs,
  fetchFromGitHub,
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

  configureFlags = [
    "--disable-allstatic"
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-include=${execline.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-lib=${execline.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
    "--with-dynlib=${execline.lib}/lib"
    "--enable-absolute-paths"
  ]
  ++ lib.optionals withNsss [
    "--enable-nsss"
    "--with-include=${nsss.dev}/include"
    "--with-lib=${nsss.lib}/lib"
    "--with-dynlib=${nsss.lib}/lib"
  ];

  meta = {
    description = "Helpers for s6-overlay";
    homepage = "https://github.com/just-containers/s6-overlay-helpers/";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
