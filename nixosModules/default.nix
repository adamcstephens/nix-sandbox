{...}: {
  config.flake.nixosModules = {
    ble2mqtt = import ./ble2mqtt.nix;
    iguanair = import ./iguanair.nix;
    logiops = import ./logiops;
    matrix-alertmanager = import ./matrix-alertmanager.nix;
    mdns-reflector = import ./mdns-reflector.nix;
  };
}
