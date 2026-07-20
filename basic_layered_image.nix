{
  dockerTools,
  buildEnv,
  s6-overlay,
  s6-overlay-helpers,
}:
dockerTools.buildLayeredImage {
  name = "s6-overlay-image";
  tag = "latest";

  contents = [ s6-overlay ];
  config = {
    Entrypoint = [ "/init" ];
  };

  extraCommands = ''
    #gets rid of a pesky warning
    rm -rf var run
    mkdir -p var run
    ln -s /run var/run
  '';

  # sutuid bit for s6-overlay-suexec
  enableFakechroot = true;
  fakeRootCommands = ''
    mkdir -p ./command
    cp ${s6-overlay-helpers}/bin/s6-overlay-suexec ./command/s6-overlay-suexec
    chmod 4755 ./command/s6-overlay-suexec
    chown 0:0 ./command/s6-overlay-suexec
  '';
}
