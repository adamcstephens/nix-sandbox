{...}: {
  config.flake.nixosModules = {
    ble2mqtt = import ./ble2mqtt.nix;
    iguanair = import ./iguanair.nix;
    logiops = import ./logiops;
    mdns-reflector = import ./mdns-reflector.nix;
  };
}
