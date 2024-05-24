inputs @ {self, ...}: {
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = {
    warnings = [];
    assertions = [];

    nixpkgs.overlays = [
      self.overlays.default
    ];
  };
  meta = {};
}
