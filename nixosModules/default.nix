{...}: {
  config.flake.nixosModules = {
    ble2mqtt = import ./ble2mqtt.nix;
    iguanair = import ./iguanair.nix;
    woodpecker-agent = import ./woodpecker-agent.nix;
    woodpecker-server = import ./woodpecker-server.nix;
  };
}
