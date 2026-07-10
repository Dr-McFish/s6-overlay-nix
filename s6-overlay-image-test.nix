{ dockerTools
, buildEnv
, s6-overlay
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

}

