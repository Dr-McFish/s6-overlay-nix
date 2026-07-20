{
  lib,
  stdenv,
  execline,
  skalibs,
  fetchFromGitHub,
  nsss ? null,
}:
let
  pkg-config = null;
in
# TODO remove pkg-config, it does not seem very useful in a nix context

stdenv.mkDerivation rec {
  pname = "s6-overlay-helpers";
  version = "0.1.2.2";

  src = fetchFromGitHub {
    owner = "just-containers";
    repo = "s6-overlay-helpers";
    rev = "v${version}";
    hash = "sha256-aZd+U8cPwQ0bn9FuhTvlomtEnsi6wkSSUb34B9qcww8=";
  };

  nativeBuildInputs = [
    # If upstream uses pkg-config for optional .pc features, keep this available:
    pkg-config
    execline.dev
  ];

  buildInputs = [
    skalibs
    execline.lib
  ]
  ++ lib.optional (nsss != null) nsss;

  # Because of security reasons, it is not possible to have setuid binaries
  # in nix store, therefore we have to modify the script
  postPatch = ''
    sed -i 's/^s6-overlay-suexec\t04755/s6-overlay-suexec\t0755/' package/modes
  '';

  configurePhase = ''
    runHook preConfigure

    SYSDEPS_DIR="${skalibs}/lib/skalibs/sysdeps"
    INCLUDE_ARGS="--with-include=${skalibs}/include --with-include=${execline.dev}/include"
    LIB_ARGS="--with-lib=${execline.lib}/lib --with-lib=${skalibs}/lib \
              --with-dynlib=${execline.lib}/lib --with-dynlib=${skalibs}/lib"

    INCLUDE_ARGS="$INCLUDE_ARGS ${lib.optionalString (nsss != null) "--with-include=${nsss}/include"}"
    LIB_ARGS="$LIB_ARGS ${
      lib.optionalString (nsss != null) "--with-lib=${nsss.lib}/lib --with-dynlib=${nsss.lib}/lib"
    }"

    ./configure \
      --disable-allstatic \
      --with-sysdeps="$SYSDEPS_DIR" \
      $INCLUDE_ARGS \
      $LIB_ARGS \
      ${lib.optionalString (nsss != null) "--enable-nsss"} \
      --enable-absolute-paths

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    # DESTDIR is supported by your build instructions; stdenv already sets it.
    make install DESTDIR="$out"

    runHook postInstall
  '';

  dontStrip = false;

  meta = {
    description = "Helpers for s6-overlay";
    homepage = "https://github.com/just-containers/s6-overlay-helpers/";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
