{
  description = "Ash Walker's Neovim config, with home-manager module";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      nixpkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          localSystem = builtins.currentSystem or system;
          crossSystem = system;
          overlays = [ ];
        }
      );
    in
    {
      formatter = lib.mapAttrs (system: pkgs: pkgs.nixfmt) nixpkgsFor;
      homeManagerModules.default = import ./home-manager.nix inputs;
      nixosModules.default = import ./nixos-module.nix;
      overlays.default = inputs.neovim.overlay;
    };
}
