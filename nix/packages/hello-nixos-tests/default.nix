{
  lib,
  inputs,
  namespace,
  system,
  pkgs,
  stdenv,
  ...
}: let
  name = "hello-nixos-tests";

  deps = pkgs.stdenv.mkDerivation {
    name = "${name}-deps";

    version = "0.1.0";
    src = lib.snowfall.fs.get-file "/";

    buildInputs = [
      pkgs.bun
      pkgs.nodejs_latest
    ];

    dontFixup = true;
    dontPatchShebangs = true;

    outputHash = "sha256-q2yEwWQpCJirjJhkjRKQSbnhOeNJqrIodBkG2IkalA8=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";

    buildPhase = ''
      bun install
    '';

    installPhase = ''
      mkdir -p $out;
      cp -r node_modules $out/
    '';
  };
in
  pkgs.stdenv.mkDerivation {
    inherit name;

    version = "0.1.0";
    src = lib.snowfall.fs.get-file "/";

    buildInputs = [
      pkgs.bun
      pkgs.nodejs_latest
    ];

    dontFixup = true;
    dontPatchShebangs = true;

    buildPhase = ''
      cp -r ${deps}/node_modules node_modules
      bun build --compile index.ts --outfile ${name}
    '';

    installPhase = ''
      mkdir -p $out/bin;
      cp hello-nixos-tests $out/bin;
    '';
  }
