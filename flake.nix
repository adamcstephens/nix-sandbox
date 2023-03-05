{
  description = "My sandbox for nix packages and modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [];

      systems = ["x86_64-linux" "aarch64-linux"];
      perSystem = {
        lib,
        pkgs,
        ...
      }: {
        packages = lib.mapAttrs' (name: _: lib.nameValuePair name (pkgs.callPackage ./packages/${name} {})) (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./packages));
      };
    };
}
