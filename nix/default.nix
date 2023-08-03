{
  config,
  lib,
  dream2nix,
  src,
  ...
}: let
  l = lib // builtins;
in {
  imports = [
    dream2nix.modules.drv-parts.pip
  ];

  deps = {nixpkgs, ...}: {
    python = nixpkgs.python3;
  };

  name = "spartan";
  version = "0.0.4";

  mkDerivation = {inherit src;};

  buildPythonPackage = {
    pythonImportsCheck = [
      config.name
    ];
  };

  pip = {
    pypiSnapshotDate = "2023-08-01";
    requirementsList = ["${src}"];
  };

  # meta = {

  # };
}
