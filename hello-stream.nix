let
  pkgs = import <nixpkgs> { };
in
pkgs.dockerTools.streamLayeredImage {
  name = "hello-stream";
  #tag = "latest";
  contents = [
    (pkgs.buildEnv {
      name = "hello-root";
      paths = with pkgs; [
        hello
        which
        coreutils
      ];
    })
  ];
  config.Cmd = [ "${pkgs.bashInteractive}/bin/bash" ];
}
