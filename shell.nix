{ nixpkgs ? import <nixpkgs> {}
, buildInputs ? import ./inputs.nix }:


nixpkgs.buildEnv {
  name = "shell";
  buildInputs = with nixpkgs.haskellPackages; [
    ghcid
    hlint
    stylish-haskell
    (ghcWithPackages buildInputs)
  ];
  paths = [];
}
