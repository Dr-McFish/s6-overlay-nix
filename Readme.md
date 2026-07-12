# Nix package for s6-overlay

s6 is a service superviser: https://www.skarnet.org/software/s6/
s6-overlay is a project that automates integration of s6 into Docker images: https://github.com/just-containers/s6-overlay

This repository is s6 overlay packaged for nix, notably for use with [dockerTools](https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools) from nixpkgs. See a basic example of how to do this in [basic_image.nix](https://github.com/Dr-McFish/s6-overlay-nix/blob/master/basic_image.nix)

