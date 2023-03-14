{
  description = "My sandbox for nix packages and modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./nixosModules
        ./packages
      ];

      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
    };
}
