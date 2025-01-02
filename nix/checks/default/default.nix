{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # You also have access to your flake's inputs.
  inputs,
  # The namespace used for your flake, defaulting to "internal" if not set.
  namespace,
  # All other arguments come from NixPkgs. You can use `pkgs` to pull checks or helpers
  # programmatically or you may add the named attributes as arguments here.
  pkgs,
  ...
}:
pkgs.nixosTest {
  name = "hello-boots";
  nodes = {
    client = {...}: {
      environment.systemPackages = with pkgs; [curl jq];
    };
    server = {
      config,
      pkgs,
      ...
    }: {
      imports = [
        inputs.self.nixosModules.default
      ];

      networking.firewall.allowedTCPPorts = [3000];

      services.helloNixosTests = {
        enable = true;
      };

      system.stateVersion = "24.05";
    };
  };

  testScript = ''
    server.wait_for_unit("default.target")

    server.wait_for_unit("helloNixosTests.service")
    server.wait_for_open_port(3000)

    client.wait_for_unit("network.target")

    actual = client.succeed("curl server:3000")
    expected = "Fastify + Bun!"

    assert expected == actual, "table query returns expected content"

  '';
}
