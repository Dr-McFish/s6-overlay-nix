#flake.nix

{

  description = "s6-overlay packaged by me";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    packages.${system} = rec { 
      default = pkgs.callPackage ./s6-overlay.nix { inherit s6-overlay-noarch s6-overlay-helpers; };

      s6-overlay-noarch = pkgs.callPackage ./s6-overlay-noarch.nix {};

      s6-overlay-helpers = pkgs.callPackage ./s6-overlay-helpers.nix { nsss = null; };

      docker-image = pkgs.callPackage ./s6-overlay-image-test.nix {
        s6-overlay = default;
        inherit s6-overlay-helpers;
      };

    };
  };
}
