{ nixpkgs ? import <nixpkgs> {} }:

let builder = src: { name ? "exe", buildInputs ? (_: []) }:
  nixpkgs.stdenv.mkDerivation {
    name = "hello";
    src = src;
    buildInputs = [(nixpkgs.haskellPackages.ghcWithPackages (h: []))];
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
