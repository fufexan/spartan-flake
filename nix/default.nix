{
  config,
  lib,
  dream2nix,
  ...
}: let
  l = lib // builtins;
  src = config.deps.fetchFromGitHub {
    owner = "WaletLab";
    repo = "Spartan";
    rev = "2ee6b4cb782333c9523962318494943029a87b0c";
    hash = "sha256-O4RFvsaz13edfSh0JjmW0vOccnA0DJhuGYKdm62CX+I=";
  };
in {
  imports = [
    dream2nix.modules.drv-parts.pip
  ];

  deps = {nixpkgs, ...}: {
    python = nixpkgs.python3;
    inherit (nixpkgs) fetchFromGitHub;
  };

  name = "spartan";
  version = "0.0.4+date=2023-07-13";

  mkDerivation = {
    inherit src;
    patches = [./setup.patch];
  };

  pip = {
    pypiSnapshotDate = "2023-08-01";
    requirementsList = ["${src}"];
  };

  # meta = {

  # };
}
