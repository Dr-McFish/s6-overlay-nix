#flake.nix

{

  description = "s6-overlay packaged by me";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      packages.${system} = rec {
        default = pkgs.callPackage ./s6-overlay.nix {
          inherit s6-overlay-noarch;
          s6-overlay-helpers = s6-overlay-helpers.override { withNsss = true; };
        };

        s6-overlay-noarch = pkgs.callPackage ./s6-overlay-noarch.nix { };

        s6-overlay-helpers = pkgs.callPackage ./s6-overlay-helpers.nix { };

        dockerImage = pkgs.callPackage ./basic_image.nix {
          s6-overlay = default;
          inherit s6-overlay-helpers;
        };

        dockerLayeredImage = pkgs.callPackage ./basic_layered_image.nix {
          s6-overlay = default;
          inherit s6-overlay-helpers;
        };
      };
    };
}
