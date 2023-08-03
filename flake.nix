{
  description = "Powerful and versatile network scanning tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    dream2nix = {
      url = "github:nix-community/dream2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    dream2nix,
    ...
  }: let
    inherit (nixpkgs) lib;

    supportedSystems = ["x86_64-linux"];
    genSystems = lib.genAttrs supportedSystems;

    settings = {config, ...}: {
      lock.repoRoot = ./.;
      lock.lockFileRel = "/locks/${config.name}.json";
    };

    _callModule = system: module:
      lib.evalModules {
        specialArgs = {
          inherit (inputs) dream2nix;
          packageSets.nixpkgs = nixpkgs.legacyPackages.${system};
        };
        modules = [
          module
          settings
          dream2nix.modules.drv-parts.core
        ];
      };
    callModule = system: module: (_callModule system module).config.public;
  in {
    packages = genSystems (system: {spartan = callModule system ./nix;});
  };
}
