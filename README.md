Trying to get understanding and intuition on arrows.

There is probably nothing useful in this repository for others, unless they
want to follow my thought processes on this.

I have a bit of a weird nix build setup here, but I wanted to keep cabal out of
the chain. Originally to keep the build system light, but given what kind of
monstrosity I ended up creating with nix, there is no longer any good reason to
keep cabal out.

You can build with `nix-build -A hello`.

You can get an environment with some tooling with `nix-shell --run zsh`

You can start ghcid inside the environment or directly with `nix-shell --run 'ghcid hello'`
