{ nixpkgs ? import <nixpkgs> {}
, buildInputs ? import ./inputs.nix }:

let builder = src: { name ? "exe" }:
  nixpkgs.stdenv.mkDerivation {
    name = "hello";
    src = src;
    buildInputs = [(nixpkgs.haskellPackages.ghcWithPackages buildInputs)];
    unpackPhase = ''
      cp $src .
    '';
    buildPhase = ''
      mkdir bin
      ghc --make -O2 $src -o ${name}
    '';
    installPhase = ''
      mkdir -p $out/bin/
      cp ${name} $out/bin/${name}
    '';
  };

in

rec {
  hello = builder ./hello.hs {};
}
