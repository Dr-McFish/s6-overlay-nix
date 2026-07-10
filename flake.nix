#flake.nix

{

  description = "s6-overlay packaged by me";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    s6-overlay = import ./s6-overlay.nix;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    packages.${system} = { 
      default = s6-overlay { inherit pkgs; };

      s6-overlay-noarch = (import ./s6-overlay-noarch.nix) { inherit pkgs; };
    };
  };
}
