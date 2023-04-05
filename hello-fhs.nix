# Possible way to run FHS containers
# https://github.com/tazjin/nixery/issues/58#issuecomment-545490157
let
  pkgs = import <nixpkgs> { };
  # Just build the FHS without the env part, that chroots you into it
  fhs = (pkgs.callPackage <nixpkgs/pkgs/build-support/build-fhs-userenv/env.nix> { }) {
    name = "container-fhs";
    targetPkgs = pkgs: with pkgs; [ hello cowsay ];
    multiPkgs = null; # Don't include glibc's multilib
  };
in
pkgs.dockerTools.buildImage {
  name = "hello-fhs";
  #tag = "latest";

  contents = pkgs.symlinkJoin {
    name = "contents";
    paths = with pkgs; [
      fhs

      # Creating directories and files like this is much faster than runAsRoot
      (pkgs.runCommand "tempfiles" { } ''
        mkdir -p $out/{var/tmp,tmp}
      '')

      #/more/paths
    ];
  };

  config = {
    Env = [
      "PATH=usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      "LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib:/usr/lib:/usr/lib32:"
    ];
    Entrypoint = [ "${pkgs.bashInteractive}/bin/bash" ];
  };
}
