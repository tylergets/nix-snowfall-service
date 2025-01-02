{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # You also have access to your flake's inputs.
  inputs,
  # The namespace used for your flake, defaulting to "internal" if not set.
  namespace,
  # All other arguments come from NixPkgs. You can use `pkgs` to pull packages or helpers
  # programmatically or you may add the named attributes as arguments here.
  pkgs,
  stdenv,
  ...
}: let
  name = "hello-nixos-tests-deps";
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

    outputHash = "sha256-9GydBAuXvv8XY1GB+uVV8c1wl3xGfSowtRYgORFRroc=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";

    buildPhase = ''
      bun install
    '';

    installPhase = ''
      ls
      mkdir -p $out;
      cp -r node_modules $out/
    '';
  }
