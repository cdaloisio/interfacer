{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  ruby = pkgs.ruby_2_5;
  bundler = pkgs.bundler.override { inherit ruby; };

in pkgs.stdenv.mkDerivation {
  name = "interfacerEnv";
  buildInputs = [
    readline
    ruby.devEnv
  ];
  shellHook = ''
    export GEM_HOME=$HOME/.gem/ruby/2.5.0
    export BUNDLE_PATH=$GEM_HOME
  '';
}
