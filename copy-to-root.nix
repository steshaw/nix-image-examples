let
  pkgs = import <nixpkgs> { };
in
pkgs.dockerTools.buildImage {
  name = "copy-to-root";
  #tag = "latest";
  copyToRoot = pkgs.buildEnv {
    name = "copy-to-root-env";
    paths = with pkgs; [
      cowsay
      coreutils
      which
      bashInteractive
    ];
  };
  config = {
    Entrypoint = [ "${pkgs.bashInteractive}/bin/bash" ];
  };
}
