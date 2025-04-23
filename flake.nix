{
  description = "Ash Walker's Neovim config, with home-manager module";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {nixpkgs, ...}:
    with builtins; let
      std = nixpkgs.lib;
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.nixfmt-rfc-style) nixpkgsFor;
      homeManagerModules.default = import ./home-manager.nix inputs;
      nixosModules.default = import ./nixos-module.nix;
      overlays.default = inputs.neovim.overlay;
    };
}
