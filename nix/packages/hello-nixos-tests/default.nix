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
      cp -r ${inputs.self.packages.${system}.hello-nixos-tests-deps}/node_modules node_modules
      bun build --compile index.ts --outfile ${name}
    '';

    installPhase = ''
      mkdir -p $out/bin;
      cp hello-nixos-tests $out/bin;
    '';
  }
