{ dockerTools
, buildEnv
, s6-overlay
, s6-overlay-helpers
} :
dockerTools.buildImage {
  name = "s6-overlay-image";
  tag = "latest";

  copyToRoot = buildEnv {
    name = "s6-overlay-env";
    paths = [
      s6-overlay
    ];
    pathsToLink = [ "/bin" "/sbin" "/command" "/etc" "/lib" "/libexec" "/package" "/" ];
  };
  config = {
    Entrypoint = [ "/init" ];
    #Cmd = [ "/bin/sh" ];
  };

  extraCommands = ''
    #gets rid of a pesky warning
    rm -rf var run
    mkdir -p var run
    ln -s /run var/run
  '';

  # sutuid bit for s6-overlay-suexec
  runAsRoot = ''
    mkdir -p ./command
    cp ${s6-overlay-helpers}/bin/s6-overlay-suexec ./command/s6-overlay-suexec
    chmod 4755 ./command/s6-overlay-suexec
    chown 0:0 ./command/s6-overlay-suexec
  '';
}

